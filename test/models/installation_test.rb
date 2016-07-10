# == Schema Information
#
# Table name: installations
#
#  id                     :integer          not null, primary key
#  wifi_installation      :string
#  outlet_installation    :string
#  fourth_tv_installation :string
#  installation_price     :string
#  self_installation      :string
#  boolean                :string
#  package_id             :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

require 'test_helper'

class InstallationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
