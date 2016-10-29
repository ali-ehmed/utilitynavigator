# == Schema Information
#
# Table name: packages
#
#  id                          :integer          not null, primary key
#  provider_id                 :integer
#  package_type_id             :integer
#  package_name                :string
#  package_description         :text
#  price_info                  :string
#  price                       :string
#  monthly_fee_after_promotion :string
#  promotion_disclaimer        :string
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  promotions                  :text
#  protection_plan_service     :string
#  lock_rates_agreement        :string
#  plan_details                :text
#

require 'test_helper'

class PackageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
