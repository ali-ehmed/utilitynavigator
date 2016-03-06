class LandingsController < ApplicationController

	def index
	end

	def providers
	end

	def twc
		@provider_banner = "twc-banner.png"
		# simply redering providers with twc
		@packages = Package.time_warner
		render :providers
	end

	def cox
		@packages = Package.cox
		# simply redering providers with cox
		@provider_banner = "cox-banner.png"
		render :providers
	end

	def charter_spectrum
		# simply redering providers with charter_spectrum
		@provider_banner = "charter-banner.png"
		@packages = Package.charter
		render :providers
	end

	def compare_packages
		ids = params[:package_ids]

		@packages = Package.where("id in (?)", ids)
		
		respond_to do |format|
			format.js
		end
	end
end
