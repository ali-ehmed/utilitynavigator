# == Schema Information
#
# Table name: package_bundles
#
#  id              :integer          not null, primary key
#  package_id      :integer
#  product_id      :integer
#  field           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  checkout_fields :string
#

class PackageBundle < ActiveRecord::Base
	belongs_to :package
	belongs_to :product

	PREMIUMS = ["EPIX", "HBO", "Cinemax", "Starz"]
	TV_SPECTRUM = ["Select", "Gold", "Silver"]
end
