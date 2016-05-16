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

	def validation_errors_notifications(object)
    return '' if object.errors.empty?

    messages = object.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    html = <<-HTML
      <div class="alert alert-danger alert-block">
      	<button type="button" class="close" data-dismiss="alert">x</button>
      	#{messages}
      </div>
    HTML

    html.html_safe
	end

	def devise_mapping
	  Devise.mappings[:user]
	end

	def resource_name
	  devise_mapping.name
	end

	def resource_class
	  devise_mapping.to
	end
end
