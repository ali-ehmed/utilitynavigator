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

class Installation < ActiveRecord::Base
  validates_presence_of :installation_price, :self_installation
  attr_accessor :checkout_select
  belongs_to :package

  after_initialize :default_values
  private

	def default_values
		# self.self_installation = true
	end
end
