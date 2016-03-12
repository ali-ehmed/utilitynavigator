class OffersController < ApplicationController
	@@broadband_providers = []
	def show
		@packages = []

		address_params = {
			address: params[:address],
			zip: params[:zipcode],
			apt: params[:apt],
			state: params[:state]
		}

		@user_address = Address.new(address_params).get_address

		session[:user_address] = @user_address

		@twc = Package.time_warner
		@charter = Package.charter
		@cox = Package.cox

		logger.debug @@broadband_providers

		unless @@broadband_providers.to_s == "zero_results"
			@providers = @@broadband_providers
			@packages = Package.broadband_providers(@providers).paginate(:page => params[:page], :per_page => 5)
		end

		respond_to do |format|
			format.html
		end
	end

	def broadband_providers
		@location = params

		@address = Address.new
		@results = @address.search_providers(@location)

		logger.debug @results
		if @results == "error".to_sym
			render json: { status: :error, msg: "There was a problem while fetching data." }
		else
			@@broadband_providers = @results
			# session[:broadband_providers] = @results
			render json: { status: :ok }
		end
	end
end
