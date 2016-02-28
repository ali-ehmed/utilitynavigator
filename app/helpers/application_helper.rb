module ApplicationHelper
	def address(params)
		if params[:address].blank? and params[:state].blank? and params[:zip].blank?
			"No result found"
		else
			"#{params[:address]} #{params[:state]} #{params[:zip]}"
		end
	end
end
