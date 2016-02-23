ActiveAdmin.register Package do

	form partial: 'package_form'

	index do
    selectable_column
    column :package_name
    column :price_info
    column :price
    column :installation_price
    column :provider
    column :package_type
    column :promotion_disclaimer do |package|
    	if package.provider.short_name == "CHARTER"
    		package.promotion_disclaimer
    	else
    		"N/A"
    	end
    end
    column :created_at
    actions
  end

	controller do
		def create
			@package = Package.new(session[:package_params])
			@package.charter_tv_spectrum = params[:charter_tv_spectrum]
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
					new_params = params.select {|k,v| bundle_keys_by_product.include?(k) }
					# params.select_keys(bundle_keys_by_product)

					logger.debug "-----#{new_params}-----"
					logger.debug "-----#{bundle_keys_by_product}-----"

					@package.package_bundles.build do |package_bundle|
						package_bundle.product_id = product.id
						package_bundle.field = new_params
						package_bundle.save
					end

					logger.debug "=====#{@package.package_bundles.inspect}======"
				end
				redirect_to admin_packages_path, notice: "Package Created"
			else
				render :product_bundles, flash: { alert: "Something went wrong while creating a new package" }
			end
		end

		def initialize_params
			params.require(:package).permit(:provider_id)
		end
	end

	# permit_params :provider_id

	collection_action :product_bundles, method: :get do
		# @params = params[:package]
		@package = Package.new(initialize_params)
		logger.debug "--#{initialize_params}"
		if !@package.valid?
			redirect_to new_admin_package_path, flash: { alert: "Provider can't be blank?" }
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
end
