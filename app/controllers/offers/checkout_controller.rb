class Offers::CheckoutController < ApplicationController
	include Wicked::Wizard
	include ApplicationHelper

	before_action :set_package, only: [:show]

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
			@getting_user_address = session[:user_address] if session[:user_address]

			@payment = Payment.new
			@payment.build_user
			@equiptment_params = params.except(:utf8, :button, :controller, :action, :offer_id, :id)
			session[:checkout_form_params] = @equiptment_params
		end
		render_wizard
	end

	private 

	def set_package
		@package = Package.find(params[:offer_id])
	end
end