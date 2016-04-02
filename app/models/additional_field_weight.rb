# == Schema Information
#
# Table name: additional_field_weights
#
#  id                :integer          not null, primary key
#  product_id        :integer
#  additional_weight :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  checkout          :boolean          default(FALSE)
#  field_type        :string
#  value             :string
#

class AdditionalFieldWeight < ActiveRecord::Base
	belongs_to :product

	validates_presence_of :product, :additional_weight, :field_type

	def to_field
		additional_weight.underscore.gsub(" ", "_").to_sym
	end

	def get_values
		eval(self.value)
	end
end
