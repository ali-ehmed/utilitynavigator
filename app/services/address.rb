require 'net/http'
require 'json'

class	Address
	def initialize(address = "")
		if address.present?
			@address = address
		end
	end

  def get_address
    return make_address(@address)
  end

  def self.get_zip_code(address)
    zip = address.split(",").reverse.first.strip if address.present?
    zip
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
  	
    # puts results

  	unless results["status"] == "OK"
  		return :zero_results
  	end

    results_for_wireline = results["Results"]["wirelineServices"] || []
    results_for_wireless = results["Results"]["wirelessServices"] || []

  	results_for_wireline = results_for_wireline.map { |v| v['providerName'] } unless results_for_wireline.blank?
		results_for_wireless = results_for_wireless.map { |v| v['providerName'] } unless results_for_wireless.blank?

  	broadbandMapProviders = results_for_wireline | results_for_wireless #intercection of two arrays

  	@all_providers = Array.new

  	puts broadbandMapProviders

  	broadbandMapProviders.each do |provider|
  		if provider.gsub(",", "").downcase.include? Provider::TIMEWARNER_COMMUNICATION.downcase
  			@all_providers << Provider.twc.name
  		end

  		if provider.gsub(",", "").downcase.include? Provider::COX_COMMUNICATION.downcase
  			@all_providers << Provider.cox.name
  		end

			if provider.gsub(",", "").downcase.include? Provider::CHARTERSPETCRUM_COMMUNICATION.downcase
				@all_providers << Provider.charter_spectrum.name
			end
  	end

  	if @all_providers.blank?
  		puts "Zero results"
  		return :zero_results
  	end

    @all_providers = [] if params[:partial_match].present?

  	return @all_providers
  end

  private

  def make_address(address)
    user_address = Array.new

    address.map do |key, value|
      unless value.blank?
        user_address << value
      end
    end
    
    user_address = user_address.join(", ")
    return user_address
  end
end