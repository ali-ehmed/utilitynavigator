ActiveAdmin.register Package do
	require 'json'

	form partial: 'package_form'

	index do
    selectable_column
    column :package_name
    column :price
    column :installation_price
		column :self_installation
    column :provider do |package|
    	package.try(:provider).try(:name)
    end
    column :package_type do |package|
    	package.try(:package_type).try(:name)
    end
    column "Disclaimer" do |package|
    	if package.provider.short_name == "CHARTER"
    		package.promotion_disclaimer
    	else
    		"N/A"
    	end
    end
    column :created_at
    actions
  end

  show do
    h3 package.package_name
      attributes_table do
	      row :price_info
	      row :price
	      row :installation_price
	      row :package_description do |package|
		    	package.package_description.html_safe
		    end
	      row :promotion_disclaimer do |package|
		    	if package.provider.short_name == "CHARTER"
		    		package.promotion_disclaimer
		    	else
		    		"N/A"
		    	end
		    end
		    row :monthly_fee_after_promotion
    	end

    package.package_bundles.each do |bundle|
    	hash = bundle.field.gsub("=>", ":")
	 		requirements = JSON.parse(hash)

			unless requirements.blank?
				panel bundle.product.name do
					h3 do
						"Product Bundles"
					end
					table_for bundle do
				 		requirements.keys.map do |key|
				 			column key, class: "fields" do
				 				if requirements[key].kind_of?(Array) then requirements[key].join(", ") else requirements[key] end
				 			end
				 		end
					end
					h3 do
						"Checkout Fields"
					end
					attributes_table_for bundle do
				 		JSON.parse(bundle.checkout_fields.gsub("=>", ":")).each do |key, value|
				 			row key, class: "fields" do
								if !value.is_a?(String) and value.is_a?(Hash)
									div class: "nested_fields_admin_preview"	do
										table_for bundle do
											value.each do |checkout_key, checkout_value|
												column checkout_key, class: "fields" do
													checkout_value.blank? ? "N/A" : checkout_value
												end
											end
										end
									end
								else
				 					value.blank? ? "N/A" : value
								end
				 			end
				 		end
					end
				end
			end
    end
  end


  sidebar "Provider", only: :show do
    attributes_table_for package do
      row :provider
      row :logo do |package|
      	if package.provider.twc?
      		image_tag "twc-logo.png", width: "70%"
      	elsif package.provider.charter?
    			image_tag "charter-logo.png", width: "70%"
      	else
      		image_tag "cox-logo.png", width: "70%"
      	end
      end
    end
  end

  sidebar "Package Type", only: :show do
    attributes_table_for package do
      row :package_type
    end
  end

	controller do
		before_action :proceed_package_incompletion, only: [:show, :edit, :update]

		def new
			@package = Package.new
			@url = admin_packages_path
			@http_method = :post
		end

		def create
			@package = Package.new(initialize_params)

			if @package.save
				@product_ids = params[:product_ids].map(&:to_i)
				@products = Product.where("id in (?)", @product_ids)

				@products.each do |product|
					product.package_bundles.create(package_id: @package.id)
				end

				if @package.provider.product_provider_preferences.blank?
					redirect_to new_admin_package_path(package: initialize_params), flash: { alert: Package::NULL_PREFERENCES }
					return
				end

				redirect_to admin_checkout_path(:package_bundles, @package.id), notice: Package::SECOND_STEP
			else
				redirect_to new_admin_package_path(package: initialize_params), flash: { alert: @package.errors.full_messages.map { |msg| content_tag(:li, msg) }.join.html_safe }
			end
		end

		def edit
			@package = resource
			@url = admin_package_path(resource)
			@http_method = :put
		end

		def update
			@package = resource
			@http_method = :put
			if resource.update_attributes(initialize_params)
				redirect_to admin_packages_path, notice: "Pakage Updated"
			else
				flash[:alert] = "Review errors below"

				render :edit
			end
		end

		private

		def proceed_package_incompletion
			if resource.package_bundles.map(&:field).any? == false
				redirect_to admin_checkout_path(:package_bundles, resource.id), notice: Package::INCOMPLETE_PACKAGE_BUNDLES
			elsif resource.package_bundles.map(&:checkout_fields).any? == false
				redirect_to admin_checkout_path(:equiptment_items, resource.id), notice: Package::INCOMPLETE_EQUIPTMENT_ITEMS
			end
		end

		def initialize_params
			params.require(:package).permit(:provider_id, :package_type_id, :price, :price_info, :package_description,
																			:package_name, :promotions, :promotion_disclaimer, :plan_details, :monthly_fee_after_promotion, :installation_price)
		end
	end

	member_action :edit_equiptment_items, method: :get do
		@package = Package.find(params[:id])
		@package_bundle = @package.package_bundles.find_by_product_id(params[:product_id])
		@checkout_fields = @package_bundle.checkout_fields
	end

	member_action :update_equiptment_items, method: :put do
		@package = Package.find(params[:id])
		@package_bundle = @package.package_bundles.find_by_product_id(params[:product_id])
		@package_bundle.update_attribute(:checkout_fields, params[@package_bundle.product.name.downcase.to_sym])

		redirect_to edit_admin_package_path(@package.id), notice: "Package Equiptment Items Updated"
	end
end
