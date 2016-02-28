class PackageBundlesController < ApplicationController
	def show
		@zipcode = params[:zipcode]

		@provider_zipcode = ProviderZipcode.find_by(zipcode: @zipcode)
		@packages = []

		@attributes = {
			address: params[:address],
			zip: params[:zipcode],
			apt: params[:apt],
			state: params[:state]
		}

		@twc = Package.twc
		@charter = Package.charter
		@cox = Package.cox

		if @provider_zipcode
			@provider = @provider_zipcode.provider
			@packages = @provider.packages
		end

		
	end
end