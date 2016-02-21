# == Schema Information
#
# Table name: providers
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Provider < ActiveRecord::Base
	# Each Provider can has multiple packages
	has_many :packages
	has_many :product_provider_preferences

	attr_accessor :additional_field_weight_ids

	validates_presence_of :name
	after_save :creating_preferences

	def creating_preferences
		@field_weight_ids = additional_field_weight_ids.reject { |c| c.empty? }
		product_provider_preferences.destroy_all if product_provider_preferences.present?
		
		if @field_weight_ids.present?
			logger.debug "#{@field_weight_ids}"
			@field_weight_ids.each do |field_weight_id|
				@preference = self.product_provider_preferences.build(additional_field_weight_id: field_weight_id)
				@preference.save
			end
		end
	end
end
