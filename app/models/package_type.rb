# == Schema Information
#
# Table name: package_types
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class PackageType < ActiveRecord::Base
	# Each Package Type can has multiple packages
	has_many :packages
end
