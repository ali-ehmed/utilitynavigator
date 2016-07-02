class Offers::CheckoutController < ApplicationController
	include Wicked::Wizard
	include ApplicationHelper

	before_action :set_package, only: [:show, :installation_fields, :update]
	# before_action :installation_fields, only: [:show]
	before_action :exclude_params, only: [:show, :update]

	steps(*Package.checkout_steps)

	def show
		logger.debug "Step: #{step}"
		case step.to_s
		when "extra_equiptments"
			begin
				@package_bundles = @package.package_bundles
				@products = Product.where("id in (?)", @package_bundles.map(&:product_id))
			rescue Exception
				redirect_to root_path, flash: { warning: "There was a problem, Please contact Tech Support Team!" }
			end
		when "reserve_order"
			@order = Order.new
			saved_equiptments
			current_user || @order.build_user
		end
		render_wizard
	end

	def update
		logger.debug "Update Step: #{step}"
		case step.to_s
		when "extra_equiptments"
			session[:checkout_form_params] = @equiptment_params
			render_wizard @package
		end
	end

	private

	def set_package
		begin
			@package = Package.find(params[:offer_id])
			@provider = @package.provider
		rescue ActiveRecord::RecordNotFound
			flash[:error] = "Package not found"
  		redirect_to offers_path
		end
	end

	def exclude_params
  	@equiptment_params = params.except(:authenticity_token, :utf8, :_method, :action, :controller, :offer_id, :id)
	end

	def saved_equiptments
		@equiptments = session[:checkout_form_params]
	end

	def installation_fields
		@charter_installation = @package.package_bundles.joins(:product).where("products.name = 'Internet'")
														  .first.try(:checkout_fields) if @package.provider.name == Provider::CHARTER_SPECTRUM

	  @cox_installation = @package.package_bundles.joins(:product).where("products.name = 'Phone'")
														  .first.try(:checkout_fields) if @package.provider.name == Provider::COX
	end
end
