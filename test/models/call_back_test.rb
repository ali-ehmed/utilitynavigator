# == Schema Information
#
# Table name: call_backs
#
#  id             :integer          not null, primary key
#  first_name     :string
#  last_name      :string
#  email          :string
#  phone_no       :string
#  address        :text
#  state          :string
#  zip            :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  time_zone      :string
#  preferred_time :time
#  preferred_date :date
#

require 'test_helper'

class CallBackTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
