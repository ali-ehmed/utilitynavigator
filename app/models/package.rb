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
#  installation_price          :string
#  promotion_disclaimer        :string
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#

class Package < ActiveRecord::Base
	belongs_to :provider
	belongs_to :package_type
end
