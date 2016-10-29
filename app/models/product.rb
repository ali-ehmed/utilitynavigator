# == Schema Information
#
# Table name: products
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Product < ActiveRecord::Base
	has_many :additional_field_weights
	accepts_nested_attributes_for :additional_field_weights, allow_destroy: true

	has_many :package_bundles, dependent: :delete_all
	accepts_nested_attributes_for :package_bundles

	scope :only_preferenced, -> { joins(:additional_field_weights).select(:name, :id).group("name", "id") }
end
