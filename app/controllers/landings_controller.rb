class LandingsController < ApplicationController
	before_action :authenticate_user!, only: [ :dashboard ]

	%w(twc cox charter_spectrum).each do |provider|
		scope_name = if provider == "twc" then "time_warner" else provider end
		before_action -> { filteration(scope_name) }, only: [ provider.to_sym ]
	end

	include Devise::Controllers::Helpers

	def index
	end

	def providers
		respond_to do |format|
			format.html
			format.js
		end
	end

	def twc
		# simply redering providers with twc

		@provider_banner = "twc-banner.png"
		render :providers
	end

	def cox
		# simply redering providers with cox
		
		@provider_banner = "cox-banner.png"
		render :providers
	end

	def charter_spectrum
		# simply redering providers with charter_spectrum

		@provider_banner = "charter-banner.png"
		render :providers
	end

	def dashboard
	end

	def compare_packages
		ids = params[:package_ids]

		@packages = Package.where("id in (?)", ids)
		
		respond_to do |format|
			format.js
		end
	end

	def load_channels
		@file = Roo::Spreadsheet.open(File.join(Rails.root, 'lib','channel_list_ordered.xlsx'))
		@channels, @channel_names = Channel.new(@file).load_all

		sleep 1

		respond_to do |format|
			format.js
		end
	end

	private

	def filteration(provider)
		@tv_packages = Package.method(provider).call.tv_filter.paginate(:page => params[:page], :per_page => 1)
		@internet_packages = Package.method(provider).call.internet_filter.paginate(:page => params[:page], :per_page => 1)
		@phone_packages = Package.method(provider).call.phone_filter.paginate(:page => params[:page], :per_page => 1)
		@bundle_packages = Package.method(provider).call.bundle_filter.paginate(:page => params[:page], :per_page => 1)
	end
end
