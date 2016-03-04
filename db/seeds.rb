# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
admin = AdminService.new.call
puts 'CREATED SUPER ADMIN USER: ' << admin.email

puts "Creating Provider"
%w(COX Time_Warner Charter_Spectrum).each do |provider|
	Provider.find_or_create_by!(name: provider.gsub("_", " "))
end

puts "Creating Package Type"
%w(single_play double_play triple_play).each do |package_type|
	PackageType.find_or_create_by!(name: package_type.humanize)
end

puts "Creating Product Type"
%w(cable internet phone).each do |product|
	Product.find_or_create_by!(name: product.humanize)
end

puts "Creating Product additional fields"
Product.all.each do |product|
	case product.name.downcase
	when :cable.to_s
		%w(no_of_channels no_of_hd_channels premiums charter_tv_spectrum).each do |field_weight|
			AdditionalFieldWeight.find_or_initialize_by(additional_weight: field_weight.humanize) do |field|
				field.product_id = product.id
				if field_weight == "charter_tv_spectrum"
					field.field_type = "Select"
					value_arr = []
					PackageBundle::TV_SPECTRUM.each do |values|
						value_arr.push values
					end
					field.value = "#{value_arr}"
				elsif field_weight == "premiums"
					field.field_type = "Select Multiple"
					value_arr = []
					PackageBundle::PREMIUMS.each do |values|
						value_arr.push values
					end
					field.value = "#{value_arr}"
				else
					field.field_type = "String"
				end
				field.save!
			end
		end

		# %(enhanced_dvr_box 1_additional_hd dta dvr_box)
	when :internet.to_s
		%w(download_speed upload_speed antivirus_protection email_accounts cloud_storage).each do |field_weight|
			AdditionalFieldWeight.find_or_initialize_by(additional_weight: field_weight.humanize) do |field|
				field.product_id = product.id
				field.field_type = "String"
				field.save
			end
		end
	end
end

# File.open(File.join(directory, 'tws_zipcodes.csv'), 'w') do |f|
#   f.puts "contents"
# end

puts "Creating Packages"
