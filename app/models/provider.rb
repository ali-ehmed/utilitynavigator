# == Schema Information
#
# Table name: providers
#
#  id                :integer          not null, primary key
#  name              :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  logo_file_name    :string
#  logo_content_type :string
#  logo_file_size    :integer
#  logo_updated_at   :datetime
#

class Provider < ActiveRecord::Base
	# Each Provider can has multiple packages
	has_many :packages
	has_many :product_provider_preferences
	has_many :provider_zipcodes

	attr_accessor :additional_field_weight_ids

	validates_presence_of :name
	after_save :creating_preferences

	# Constants for broadband provider api
	COX_COMMUNICATION = "Cox"
	TIMEWARNER_COMMUNICATION = "Time Warner"
	CHARTERSPETCRUM_COMMUNICATION = "Charter"

	COX = "COX"
	CHARTER_SPECTRUM = "Charter Spectrum"
	TIME_WARNER = "Time Warner"

	# has_attached_file :logo, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  

  has_attached_file :logo, styles: { medium: "400x400>", thumb: "100x100>" },
    :storage => :dropbox,
    :dropbox_credentials => Rails.root.join("config/initializers/dropbox.yml"),
    :dropbox_visibility => 'public'
  validates_attachment_content_type :logo, content_type: /\Aimage\/.*\Z/

	def creating_preferences
		@field_weight_ids = additional_field_weight_ids
		if @field_weight_ids.present?
		@field_weight_ids = @field_weight_ids.reject { |c| c.empty? }
		
			product_provider_preferences.destroy_all if product_provider_preferences.present?
		
			logger.debug "#{@field_weight_ids}"
			@field_weight_ids.each do |field_weight_id|
				@preference = self.product_provider_preferences.build(additional_field_weight_id: field_weight_id)
				@preference.save
			end
		end
	end

	def short_name
		name.upcase.split(" ").first
	end

	def acronym
		if short_name == "TIME"
			"twc"
		else
			short_name.downcase
		end
	end

	
	if ActiveRecord::Base.connection.table_exists? 'providers'
		class << self
			[["cox", 1], ["twc", 2], ["charter_spectrum", 3]].each do |provider|
				define_method("#{provider.first}") do
					find_by(id: provider.second)
				end
			end
		end

		# To check if provider specified is true
		all.map(&:acronym).map do |provider|
			define_method("#{provider}?") do
				self.acronym == provider
			end
		end
	end
end
