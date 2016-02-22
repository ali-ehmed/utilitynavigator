# == Schema Information
#
# Table name: additional_field_weights
#
#  id                :integer          not null, primary key
#  product_id        :integer
#  additional_weight :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class AdditionalFieldWeight < ActiveRecord::Base
	belongs_to :product

	def to_field
		additional_weight.underscore.gsub(" ", "_").to_sym
	end
end
