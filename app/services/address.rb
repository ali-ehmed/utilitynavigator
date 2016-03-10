require 'net/http'
require 'json'

class	Address
	def initialize(address = "")
		if address.present?
			chomp_user_address(address)
		end
	end

	def chomp_user_address(address)
  	@user_address = Array.new

  	unless address.blank?
			@getting_user_address = address
		else
			return :session_expired
		end

		@getting_user_address.map do |key, value|
			unless value.blank?
				@user_address << value
			end
		end
		

		@user_address = @user_address.join(", ")
		return true
  end

  def search_providers(params)
  	address = params[:address].split(" ").join("-")

  	puts address

  	geocoder = "http://www.broadbandmap.gov/internet-service-providers/#{address}/lat=#{params[:lat]}/long=#{params[:lng]}/.json"
    
    begin
      results = JSON.parse(open(geocoder).read)
    rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError, Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
      puts e.message
      return :error
    end
  	

  	unless results["status"] == "OK"
  		puts geocoder
  		return :zero_results
  	end

  	wirelineServices = results["Results"]["wirelineServices"].map { |v| v['providerName'] }
		wirelessServices = results["Results"]["wirelessServices"].map { |v| v['providerName'] }

  	broadbandMapProviders = wirelineServices | wirelessServices

  	@all_providers = Array.new

  	# puts broadbandMapProviders

  	broadbandMapProviders.each do |provider|
  		if provider == "Time Warner Cable Inc."
  			@all_providers << "Time Warner"
  		end

  		if provider == "COXCOM INC"
  			@all_providers << "COX"
  		end

			if provider == "Charter Communications, Inc."
				@all_providers << "Charter"
			end
  	end

  	if @all_providers.blank?
  		puts "Zero results"
  		return :zero_results
  	end

  	return @all_providers
  end
end