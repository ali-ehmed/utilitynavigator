# == Schema Information
#
# Table name: product_provider_preferences
#
#  id                         :integer          not null, primary key
#  provider_id                :integer
#  additional_field_weight_id :integer
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#

class ProductProviderPreference < ActiveRecord::Base
	belongs_to :provider
	belongs_to :additional_field_weight

	scope :preferences_of_product, -> (product_id) { joins(:additional_field_weight).where("additional_field_weights.product_id = ?", product_id) }
end
