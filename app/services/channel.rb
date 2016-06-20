# Ali Ahmed :-> (Software Engineer - Ruby on Rails)
# Custom logic to load all the channels from the excel.
class Channel
	def initialize(file)
		@excel = file
	end

	def load_all(provider)
		channels_name = Array.new

		header = @excel.row(1)

		# getting all the providers in array
		providers = Array.new
		@excel.column(3).each do |provider_1|
			providers << provider_1 unless providers.include?(provider_1)
		end

		return [] unless providers.include?(provider)

		# get all channel types in array according to current provider
		channel_provider_types = Array.new
		(2.upto(@excel.last_row)).each do |row_id|
			row = Hash[[header, @excel.row(row_id)].transpose]

			if row["provider"] == provider
				channel_provider_types << row["channel_type"] unless channel_provider_types.include?(row["channel_type"])
			end
		end

		(2.upto(@excel.last_row)).each do |row_id|
			row = Hash[[header, @excel.row(row_id)].transpose]
			is_present = false

			if row["provider"] == provider
				# this checks if channel already presents in the array
				# then just set the channel type in the channel type keys and return present
				channels_name.select do |channel|
					if channel["channel"] == row["channel_name"]

						channel[row["channel_type"].downcase.tr(" ", "_")] = row["channel_type"]
						is_present = true
					end
				end

				# if channel name was already present then skipping the loop
				if is_present == true
					is_present = false
					next
				end

				provider_hash = Hash.new
				provider_hash["channel"] = row["channel_name"]

				# putting channel types as hash keys
				# setting "no" to default
				channel_provider_types.each do |name|
					provider_hash[name.downcase.tr(" ", "_")] = "no"
				end

				# setting the channel type for the first channel

				provider_hash[row["channel_type"].downcase.tr(" ", "_")] = row["channel_type"]
				channels_name << provider_hash
			end
		end

		return channels_name, channel_provider_types
	end
end
