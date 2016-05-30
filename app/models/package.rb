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

	has_many :payments, dependent: :delete_all
	accepts_nested_attributes_for :payments

	attr_accessor :product_ids, :charter_tv_spectrum

	cattr_accessor :checkout_steps do
		[:extra_equiptments, :payments]
	end

	SINGLE_PLAY = "Single play"
	DOUBLE_PLAY = "Double play"
	TRIPLE_PLAY = "Triple play"

	validates_presence_of :provider_id
	validates :price_info, length: { maximum: 80 }

	after_create :set_promotion_disclaimer

	scope :time_warner, -> { joins(:provider).where("providers.name = 'Time Warner'") }
	scope :charter_spectrum, -> { joins(:provider).where("providers.name = 'Charter Spectrum'") }
	scope :cox, -> { joins(:provider).where("providers.name = 'COX'") }

	scope :phone_filter, -> { joins(:package_type, :package_bundles => :product).where("products.name iLIKE '%Phone%' and package_types.name = ?", SINGLE_PLAY) }
	scope :internet_filter, -> { joins(:package_type, :package_bundles => :product).where("products.name iLIKE '%Internet%' and package_types.name = ?", SINGLE_PLAY) }
	scope :tv_filter, -> { joins(:package_type, :package_bundles => :product).where("products.name iLIKE '%Cable%' and package_types.name = ?", SINGLE_PLAY) }
	scope :bundle_filter, -> { joins(:package_type).where("package_types.name iLIKE ? or package_types.name iLIKE ? or package_types.name iLIKE ?", SINGLE_PLAY, DOUBLE_PLAY, TRIPLE_PLAY) }

	scope :broadband_providers, -> (providers) { joins(:provider, :package_type, :package_bundles => :product)
																							 .select("packages.id, 
																							 					package_name, 
																						 						provider_id, 
																						 						plan_details, 
																						 						price_info, 
																						 						price, 
																						 						package_description, 
																						 						promotions")
																							 .group("packages.id, package_name")
																							 .where("providers.name in (?)", providers)
																							 .order("CAST(coalesce(price, '0') AS double precision) asc")
																							}

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
