class Channel
	def initialize(file)
		@exel = file
	end

	def load_all
		channels_name = Array.new
		
		header = @exel.row(1)

		channel_providers = Array.new
		@exel.column(2).each do |provider|
			channel_providers << provider unless channel_providers.include?(provider)
		end

		# puts channel_providers

		(2.upto(@exel.last_row)).each do |row_id|
			row = Hash[[header, @exel.row(row_id)].transpose]
			

			if channels_name.include?(row["channel_listing"])
				channels_name << row
				channel_providers.each do |name|
					provider_hash = Hash.new
					# provider_hash[name.downcase.tr(" ", "_")] = 
				end
			else
			end
		end

		channels_name.each do |channel_name|
			channel_providers.each do |name|
				provider_hash = Hash.new
				provider_hash[name.downcase.tr(" ", "_")] = 
			end
			channels_list << {
				channel: row["channel_listing"],

			}
		end

		return channels_list
	end
end