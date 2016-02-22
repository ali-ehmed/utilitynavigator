# == Schema Information
#
# Table name: provider_zipcodes
#
#  id          :integer          not null, primary key
#  zipcode     :string
#  provider_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class ProviderZipcode < ActiveRecord::Base
	belongs_to :provider

	scope :time_warner_zipcodes, -> { joins(:provider).where("providers.name = ?", 'Time Warner') }
	scope :charter_zipcodes, -> { joins(:provider).where("providers.name = ?", 'Charter Spectrum') }
	scope :cox_zipcodes, -> { joins(:provider).where("providers.name = ?", 'COX') }

	class << self
		def import_zipcodes(file, provider)
			spreadsheet = open_spreadsheet(file)
			header = spreadsheet.row(1)
			(2..spreadsheet.last_row).each do |row_id|
				row = Hash[[header, spreadsheet.row(row_id)].transpose]
				provider_zipcode = provider.provider_zipcodes.find_by(:zipcode => row["zipcode"]) || provider.provider_zipcodes.build
				provider_zipcode.zipcode = row["zipcode"].to_i
				provider_zipcode.save!
			end
		end

		def open_spreadsheet(file)
			case File.extname(file.original_filename)
			when ".csv" then Roo::CSV.new(file.path)
			when ".xls" then Roo::Excel.new(file.path)
			when ".xlsx" then Roo::Excelx.new(file.path)
			else raise "Unknown file type #{file.original_filename}"
			end
		end
	end
end
