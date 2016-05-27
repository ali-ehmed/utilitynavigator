class Offers::CheckoutController < ApplicationController
	include Wicked::Wizard
	include ApplicationHelper

	before_action :set_package, only: [:show, :charter_installation]

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
			@equiptment_params = params.except(:utf8, :button, :controller, :action, :offer_id, :id)
			session[:checkout_form_params] = @equiptment_params
		end
		render_wizard
	end
	
	def update
		logger.debug "Update Step: #{step}"
		redirect_to root_path, notice: Payment::RESERVED_MESSAGE
	end

	def set_package
  	# @directory_name = @equiptment_params["directory_entered_name"] if @package.provider.cox?
  	# @transfer_phone_number = @equiptment_params["transfer_phone_number"] if @package.provider.charter?
  end

	private 

	def set_package
		begin
			@package = Package.find(params[:offer_id])
		rescue ActiveRecord::RecordNotFound
			flash[:error] = "Package not found"
  		redirect_to offers_path
		end
	end

	def charter_installation
		@charter_fields = @package.package_bundles.joins(:product).where("products.name = 'Internet'")
														  .first.try(:checkout_fields)
	end
end