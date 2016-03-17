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
#  promotions                  :text
#

class Package < ActiveRecord::Base
	belongs_to :provider
	belongs_to :package_type

	has_many :package_bundles
	accepts_nested_attributes_for :package_bundles

	has_many :payments
	accepts_nested_attributes_for :payments

	attr_accessor :product_ids, :charter_tv_spectrum

	cattr_accessor :checkout_steps do
		[:extra_equiptments, :payments]
	end

	validates_presence_of :provider_id
	validates :price_info, length: { maximum: 80 }

	after_create :set_promotion_disclaimer

	scope :time_warner, -> { joins(:provider).where("providers.name = 'Time Warner'") }
	scope :charter_spectrum, -> { joins(:provider).where("providers.name = 'Charter Spectrum'") }
	scope :cox, -> { joins(:provider).where("providers.name = 'COX'") }

	scope :phone_filter, -> { joins(:package_bundles => :product).where("products.name LIKE '%Phone%'") }
	scope :internet_filter, -> { joins(:package_bundles => :product).where("products.name LIKE '%Internet%'") }
	scope :tv_filter, -> { joins(:package_bundles => :product).where("products.name LIKE '%Cable%'") }
	scope :bundle_filter, -> { joins(:package_type).where("package_types.name LIKE '%Single%' or package_types.name LIKE '%Double%' or package_types.name LIKE '%Triple%'") }

	scope :broadband_providers, -> (providers) { joins(:provider).where("providers.name in (?)", providers) }

	CABLE_TV = ["Primary TV", "2nd TV", "3rd TV", "4th TV"]

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
			if read_attribute(:price_info).include?("*")
				read_attribute(:price_info).split("*")[1].strip 
			else
				read_attribute(:price_info).strip 
			end
		end
	end
end
