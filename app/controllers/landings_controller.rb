class LandingsController < ApplicationController
	before_action :destroy_search_provider, only: [:index]

	def index
	end

	def providers
		respond_to do |format|
			format.html
			format.js
		end
	end

	def twc
		@provider_banner = "twc-banner.png"
		# simply redering providers with twc

		@tv_packages = Package.time_warner.tv_filter.paginate(:page => params[:page], :per_page => 1)
		@internet_packages = Package.time_warner.internet_filter.paginate(:page => params[:page], :per_page => 1)
		@phone_packages = Package.time_warner.phone_filter.paginate(:page => params[:page], :per_page => 1)
		@bundle_packages = Package.time_warner.bundle_filter.paginate(:page => params[:page], :per_page => 1)

		render :providers
	end

	def cox
		# simply redering providers with cox

		@tv_packages = Package.cox.tv_filter.paginate(:page => params[:page], :per_page => 1)
		@internet_packages = Package.cox.internet_filter.paginate(:page => params[:page], :per_page => 1)
		@phone_packages = Package.cox.phone_filter.paginate(:page => params[:page], :per_page => 1)
		@bundle_packages = Package.cox.bundle_filter.paginate(:page => params[:page], :per_page => 1)
		
		@provider_banner = "cox-banner.png"
		render :providers
	end

	def charter_spectrum
		# simply redering providers with charter_spectrum
		@provider_banner = "charter-banner.png"

		@tv_packages = Package.charter.tv_filter.paginate(:page => params[:page], :per_page => 1)
		@internet_packages = Package.charter.internet_filter.paginate(:page => params[:page], :per_page => 1)
		@phone_packages = Package.charter.phone_filter.paginate(:page => params[:page], :per_page => 1)
		@bundle_packages = Package.charter.bundle_filter.paginate(:page => params[:page], :per_page => 1)

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
