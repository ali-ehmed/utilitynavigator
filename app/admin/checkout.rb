ActiveAdmin.register Checkout do
  config.comments = false
  before_filter do @skip_sidebar = true end
  menu false
  config.clear_action_items!   # this will prevent the 'new button' showing up


  controller do
    include Wicked::Wizard
    steps :package_bundles, :equiptment_items
    layout 'active_admin'
    before_action :set_package

    def show
      case step
      when :package_bundles
        @provider = @package.provider
        @provider_preferences = @provider.product_provider_preferences
      end
      render_wizard
    end

    def update
      case step
      when :package_bundles
        @provider = @package.provider
        @provider_preferences = @provider.product_provider_preferences
        bundle_keys_by_product = Array.new

        @package.charter_tv_spectrum = params["charter_tv_spectrum"]
        @package.save
        
        for product in @products do
        	@provider_preferences.preferences_of_product(product.id).each do |preference|
						bundle_keys_by_product << preference.additional_field_weight.to_field.to_s
					end

        	bundle_params = ""
					bundle_params = params.select {|k,v| bundle_keys_by_product.include?(k) }

					package_bundle = @package.package_bundles.find_by_product_id(product)
					package_bundle.field = bundle_params
					package_bundle.save
        end
      when :equiptment_items

  			@package.protection_plan_service = params["protection_plan_service"] || ""
  			@package.lock_rates_agreement = params["lock_rates_agreement"] || ""
        @package.save

        for product in @products do
          exclude_garbage_fields(params, product)
          package_bundle = @package.package_bundles.find_by_product_id(product)
          package_bundle.checkout_fields = params[product.to_sym]
          package_bundle.save
        end

        redirect_to admin_packages_path, notice: Package::FINAL_STEP and return
      end

      render_wizard @package
    end

    private

    def exclude_garbage_fields(params, product)
      params[product.to_sym].delete("checkout_select")
      params[product.to_sym].each do |key, value|
        if !value.is_a?(String) and value.is_a?(Hash)
          value.delete("checkout_select")
        end
      end
    end

    def set_package
      begin
        @package = Package.find(params[:package_id])
      rescue ActiveRecord::RecordNotFound
        flash[:error] = "Package not found"
        redirect_to admin_packages_path and return
      end
      @package_bundles = @package.package_bundles.includes(:product)
      @products = @package_bundles.map(&:product)
    end
  end
end
