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

	has_many :package_bundles
	accepts_nested_attributes_for :package_bundles

	attr_accessor :product_ids, :charter_tv_spectrum

	validates_presence_of :provider_id

	after_create :set_promotion_disclaimer

	scope :twc, -> { joins(:provider).where("providers.name = 'Time Warner'") }
	scope :charter, -> { joins(:provider).where("providers.name = 'Charter Spectrum'") }
	scope :cox, -> { joins(:provider).where("providers.name = 'COX'") }

	def set_promotion_disclaimer
		if self.provider.short_name == "CHARTER" and self.charter_tv_spectrum
			update_attribute(:promotion_disclaimer, "#{price} & #{self.charter_tv_spectrum}")
		end
	end

	def upadting_content_to_html
		if self.package_description
			update_attribute(:package_description, self.package_description.html_safe)
		end
	end

	def price_info
		if read_attribute(:price_info)
			read_attribute(:price_info).split("*")[1].strip if read_attribute(:price_info).include?("*")
		end
	end
end
