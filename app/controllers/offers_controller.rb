class OffersController < ApplicationController
	@@broadband_providers = []
	include PackagesHelper

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

		unless broadband_search.to_s == "zero_results"
			@providers = broadband_search
			@packages = Package.broadband_providers(@providers)
		end

		if @packages.length > 0
			# Applying product filters
			if params[:filters] and params[:filters].present?
				@packages = @packages.send(params[:filters])
			end

			@count_twc = @packages.try("time_warner").length
			@count_charter = @packages.try("charter_spectrum").length
			@count_cox = @packages.try("cox").length

			@packages = @packages.paginate(:page => params[:page], :per_page => 6)
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
