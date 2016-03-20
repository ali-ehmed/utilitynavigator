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

		unless address_params[:address].blank?
			session[:zip_code] = address_params[:zip]

			user_address = Address.new(address_params).get_address
			session[:user_address] = user_address
		end

		@twc = Package.time_warner
		@charter = Package.charter_spectrum
		@cox = Package.cox

		logger.debug user_address

		unless broadband_search.to_s == "zero_results"
			@providers = broadband_search
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
			session[:broadband_search] = @results
			render json: { status: :ok }
		end
	end
end
