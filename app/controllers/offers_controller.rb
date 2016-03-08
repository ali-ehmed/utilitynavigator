class OffersController < ApplicationController
	def show
		# @zipcode = params[:zipcode]

		# @provider_zipcode = ProviderZipcode.find_by(zipcode: @zipcode)
		# @packages = []

		# @full_address = {
		# 	address: params[:address],
		# 	zip: params[:zipcode],
		# 	apt: params[:apt],
		# 	state: params[:state]
		# }

		# session[:user_address] = @full_address

		# @twc = Package.time_warner
		# @charter = Package.charter
		# @cox = Package.cox

		# if @provider_zipcode
		# 	@provider = @provider_zipcode.provider
		# 	@packages = @provider.packages.paginate(:page => params[:page], :per_page => 5)
		# end

		@latitude = params[:lat]
		@longtitude = params[:lng]
		@user_address = params[:address]

		@address = Address.new

		@results = @address.search_providers(@user_address, @latitude, @longtitude)

		logger.debug "-------____#{@results}"

		respond_to do |format|
			format.html
			format.json { render :json => { status: :ok } }
		end
	end
end
