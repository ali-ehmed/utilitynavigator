class PackageBundlesController < ApplicationController
	def show
		@zipcode = params[:zipcode]

		@provider_zipcode = ProviderZipcode.find_by(zipcode: @zipcode)
		@packages = []

		if @provider_zipcode
			# render :html => { template:  }
			# render :json => { status: "not found" }
			# return

			@provider = @provider_zipcode.provider

			@packages = @provider.packages
		end

		
	end
end