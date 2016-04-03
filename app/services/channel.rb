# Ali Ahmed :-> (Software Engineer - Ruby on Rails)
# Custom logic to load all the channels from the exel.
class Channel
	def initialize(file)
		@exel = file
	end

	def load_all
		channels_name = Array.new

		header = @exel.row(1)

		# getting all the types in array
		channel_providers = Array.new
		@exel.column(2).each_with_index do |provider, row|
			if row > 0 # excluding headings
				channel_providers << provider unless channel_providers.include?(provider)
			end
		end

		(2.upto(@exel.last_row)).each do |row_id|
			row = Hash[[header, @exel.row(row_id)].transpose]
			is_present = false

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
			channel_providers.each do |name|
				provider_hash[name.downcase.tr(" ", "_")] = "no"
			end

			# setting the channel type for the first channel
			provider_hash[row["channel_type"].downcase.tr(" ", "_")] = row["channel_type"]

			channels_name << provider_hash
		end

		return channels_name, channel_providers
	end
end