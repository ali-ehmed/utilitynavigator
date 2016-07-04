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

	has_many :package_bundles, dependent: :delete_all
	accepts_nested_attributes_for :package_bundles

	has_many :orders, dependent: :delete_all
	accepts_nested_attributes_for :orders

	attr_accessor :product_ids, :charter_tv_spectrum
	after_initialize :default_values

	extend PackagesHelper

	cattr_accessor :checkout_steps do
		[:extra_equiptments, :reserve_order]
	end

	SINGLE_PLAY = "Single play"
	DOUBLE_PLAY = "Double play"
	TRIPLE_PLAY = "Triple play"

	NULL_PREFERENCES = "There are no preferences present for this package"
	SECOND_STEP = "Please provide items for package bundles"
	FINAL_STEP = "Package has been created successfully"
	INCOMPLETE_PACKAGE_BUNDLES = "Please provide all information of this package"
	INCOMPLETE_EQUIPTMENT_ITEMS = "Please provide the equiptment items for this package"

	# Length of packages displaying bottom on provider pages
	PACKAGE_PER_PAGE_LENGTH = 3

	validates_presence_of :provider_id,
												:price, :package_name, :package_description, :price_info, :promotions,
												:plan_details, :installation_price

	validates :price_info, length: { maximum: 80 }

	after_create :set_promotion_disclaimer

	scope :time_warner, -> { joins(:provider).where("providers.name = 'Time Warner'") }
	scope :charter_spectrum, -> { joins(:provider).where("providers.name = 'Charter Spectrum'") }
	scope :cox, -> { joins(:provider).where("providers.name = 'COX'") }

	scope :grouped_packages, -> { joins(:package_type, :package_bundles => :product) }

	scope :phone_filter, -> { grouped_packages
														.where("products.name iLIKE '%Phone%' and package_types.name = ?", SINGLE_PLAY)
														.low_price_packages
	 												}
	scope :internet_filter, -> 	{ grouped_packages
																.where("products.name iLIKE '%Internet%' and package_types.name = ?", SINGLE_PLAY)
																.low_price_packages
															}
	scope :tv_filter, -> 	{ grouped_packages
													.where("products.name iLIKE '%Cable%' and package_types.name = ?", SINGLE_PLAY)
													.low_price_packages
												}

	scope :bundle_filter, -> {
															joins(:package_type)
															.where("package_types.name in (?)", [DOUBLE_PLAY, TRIPLE_PLAY])
															.low_price_packages
														}

	scope :low_price_packages, -> { order("CAST(coalesce(price, '0') AS double precision) asc") }

	scope :broadband_providers, -> (providers) { grouped_packages.joins(:provider)
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
																							 .low_price_packages
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

	class << self
		def filter_with filters
			where("products.name in (?) and package_types.name = ?", filters, get_package_type(filters))
		  .having("count(distinct products.name) = ?", filters.length)
		end
	end

	private
		def default_values
			self.self_installation = true
		end
end
