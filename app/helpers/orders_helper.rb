module OrdersHelper
	def status_label(status)
		case status
		when "pending"
			"warning"
		when "declined"
			"danger"
		else
			"success"
		end
	end
end
