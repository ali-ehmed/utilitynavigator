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

  def search_providers(address, latitude, longtitude)
  	address = address.split(" ").join("-")
  	puts address
  	# JSON.parse(open("http://www.broadbandmap.gov/internet-service-providers/#{address}/lat=#{latitude}/long=#{longtitude}/.json").read)
  	geocoder = "http://www.broadbandmap.gov/internet-service-providers/#{address}/lat=#{latitude}/long=#{longtitude}/.json"
  	# uri = URI(geocoder)
  	results = JSON.parse(open(geocoder).read)
  	if results["status"] == "OK"
  		wirelineServices = results["Results"]["wirelineServices"]
  		wirelessServices = results["Results"]["wirelessServices"]
  	end
  	return wirelineServices.map(&:providerName)
  end
end