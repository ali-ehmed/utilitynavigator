# == Schema Information
#
# Table name: provider_zipcodes
#
#  id          :integer          not null, primary key
#  zipcode     :string
#  provider_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class ProviderZipcodeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
