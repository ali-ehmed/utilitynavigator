ActiveAdmin.register Package do
	require 'json'

	form partial: 'package_form'

	index do
    selectable_column
    column :package_name
    column :price
    column :installation_price
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

	    		table_for bundle do
				 		requirements.keys.map do |key|
				 			column key, class: "fields" do
				 				if requirements[key].kind_of?(Array) then requirements[key].join(", ") else requirements[key] end
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
		def create
			unlock_package_params = ActiveSupport::HashWithIndifferentAccess.new(session[:package_params])
			@package = Package.new(unlock_package_params)

			package_bundle_params = session[:package_bundles_params]

			@package.charter_tv_spectrum = package_bundle_params["charter_tv_spectrum"]

			@package.protection_plan_service = params["protection_plan_service"] || ""
			@package.lock_rates_agreement = params["lock_rates_agreement"] || ""

			if @package.save
				@product_ids = params[:product_ids].map(&:to_i)
				@products = Product.where("id in (?)", @product_ids)
				@provider = Provider.find(@package.provider_id)

				@provider_preferences = @provider.product_provider_preferences

				for product in @products do
					bundle_keys_by_product = Array.new
					@provider_preferences.preferences_of_product(product.id).each do |preference|
						bundle_keys_by_product << preference.additional_field_weight.to_field.to_s
					end

					bundle_params = "" 
					bundle_params = package_bundle_params.select {|k,v| bundle_keys_by_product.include?(k) }
					# params.select_keys(bundle_keys_by_product)

					@package.package_bundles.build do |package_bundle|
						package_bundle.product_id = product.id
						package_bundle.field = bundle_params
						case product.name.downcase
						when "cable"
							package_bundle.checkout_fields = params[:cable]
						when "internet"
							package_bundle.checkout_fields = params[:internet]
						else
							package_bundle.checkout_fields = params[:phone]
						end
						package_bundle.save
					end
				end


				redirect_to admin_packages_path, notice: "Package Created"
			else
				render :product_bundles, flash: { alert: "Something went wrong while creating a new package" }
			end
		end

		def new
			@package = Package.new
			@url = product_bundles_admin_packages_path
			@http_method = :post
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

		def initialize_params
			params.require(:package).permit(:provider_id, :package_type_id, :price, :price_info, :package_description,
																			:package_name, :promotions, :promotion_disclaimer, :plan_details, :monthly_fee_after_promotion, :installation_price)
		end
	end

	# permit_params :provider_id

	collection_action :product_bundles, method: :post do
		# @params = params[:package]
		params.except(:promotions)

		@package = Package.new(initialize_params)
		logger.debug "--#{initialize_params}"

		if !@package.valid?
			redirect_to new_admin_package_path, flash: { alert: "Review errors" }
			return
		end

		session[:package_params] = params[:package]

		@product_ids = params[:product_ids].map(&:to_i)
		@products = Product.where("id in (?)", @product_ids)
		@provider = Provider.find(params[:package][:provider_id])

		@provider_preferences = @provider.product_provider_preferences

		if @provider_preferences.blank?
			redirect_to new_admin_package_path, flash: { alert: "There are no preferences present for #{@provider.name}" }
			return
		end

	 	respond_to do |format|
			format.html
		end
	end


	collection_action :ordering_items, method: :get do
		session[:package_bundles_params] = params
		@product_ids = params[:product_ids].map(&:to_i)
		@products = Product.where("id in (?)", @product_ids)
		@provider = Provider.find(params[:provider_id])

		respond_to do |format|
			format.html
		end
	end

	member_action :edit_ordering_items, method: :get do 
		@package = Package.find(params[:id])
		@package_bundle = @package.package_bundles.find_by_product_id(params[:product_id])
		@checkout_fields = @package_bundle.checkout_fields
	end

	member_action :update_ordering_items, method: :put do 
		@package = Package.find(params[:id])
		@package_bundle = @package.package_bundles.find_by_product_id(params[:product_id])
		@package_bundle.update_attribute(:checkout_fields, params[@package_bundle.product.name.downcase.to_sym])

		redirect_to edit_admin_package_path(@package.id), notice: "Package Updated"
	end

	member_action :remove_package_product, method: :delete do 
		@package = Package.find(params[:id])
		@package_bundle = @package.package_bundles.find_by_product_id(params[:product_id])
		@package_bundle.destroy
		
		case @package.package_bundles.count
		when 1
			@package_type = PackageType.find_by_name(Package::SINGLE_PLAY)
		when 2
			@package_type = PackageType.find_by_name(Package::DOUBLE_PLAY)
		when 3
			@package_type = PackageType.find_by_name(Package::TRIPLE_PLAY)
		end

		@package.package_type_id = @package_type.id
		@package.save
		
		@product = Product.find(params[:product_id])
		redirect_to edit_admin_package_path(@package.id), notice: "Package Product '#{@product.name}' Created"
	end
end
