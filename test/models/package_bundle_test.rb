# == Schema Information
#
# Table name: package_bundles
#
#  id         :integer          not null, primary key
#  package_id :integer
#  product_id :integer
#  field      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class PackageBundleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
