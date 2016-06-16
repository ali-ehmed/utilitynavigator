class Offers::CheckoutController < ApplicationController
	include Wicked::Wizard
	include ApplicationHelper

	before_action :set_package, only: [:show, :installation_fields]
	before_action :installation_fields, only: [:show]
	before_action :exclude_params, only: [:show]

	steps *Package.checkout_steps

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
		when "payments"
			@payment = Payment.new
			current_user || @payment.build_user
			session[:checkout_form_params] = @equiptment_params
		end
		render_wizard
	end
	
	def update
		logger.debug "Update Step: #{step}"
		redirect_to root_path, notice: Payment::RESERVED_MESSAGE
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
  	@equiptment_params = params.except(:utf8, :button, :controller, :action, :offer_id, :id)
  end

	def installation_fields
		@charter_installation = @package.package_bundles.joins(:product).where("products.name = 'Internet'")
														  .first.try(:checkout_fields) if @package.provider.name == Provider::CHARTER_SPECTRUM

	  @cox_installation = @package.package_bundles.joins(:product).where("products.name = 'Phone'")
														  .first.try(:checkout_fields) if @package.provider.name == Provider::COX
	end
end