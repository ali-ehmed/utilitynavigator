class OffersController < ApplicationController
	def show
		@packages = []

		@full_address = {
			address: params[:address],
			zip: params[:zipcode],
			apt: params[:apt],
			state: params[:state]
		}

		@user_address = Array.new

		@full_address.map do |key, value|
			unless value.blank?
				@user_address << value
			end
		end

		@user_address = @user_address.join(", ")

		session[:user_address] = @user_address

		@twc = Package.time_warner
		@charter = Package.charter
		@cox = Package.cox

		logger.debug session[:broadband_providers]

		unless session[:broadband_providers] == "zero_results".to_sym
			@providers = session[:broadband_providers]
			@packages = Package.joins(:provider).where("providers.name in (?)", @providers)
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
			session[:broadband_providers] = @results
			render json: { status: :ok }
		end
	end
end
