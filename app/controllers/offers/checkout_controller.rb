class Offers::CheckoutController < ApplicationController
	include Wicked::Wizard

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
		end
		render_wizard
	end

	private 

	def set_package
		@package = Package.find(params[:offer_id])
	end
end