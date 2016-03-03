module ApplicationHelper
	def address(params)
		if params[:address].blank? and params[:state].blank? and params[:zip].blank?
			"No result found"
		else
			"#{params[:address]} #{params[:state]} #{params[:zip]}"
		end
	end

	def get_in_hash(fields)
		hash = fields.gsub("=>", ":")
 		return JSON.parse(hash)
	end

	def provider_logo(provider)
		@provider = provider
		if @provider.twc?
			image_tag "twc-logo.png", class: "img-rounded img-responsive"
		elsif @provider.charter?
			image_tag "charter-logo.png", class: "img-rounded img-responsive"
		else
			image_tag "cox-logo.png", class: "img-rounded img-responsive"
		end
	end
end
