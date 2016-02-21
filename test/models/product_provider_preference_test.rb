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

require 'test_helper'

class ProductProviderPreferenceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
