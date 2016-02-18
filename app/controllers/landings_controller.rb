class LandingsController < ApplicationController
	def send_email
		RequestCallBack.call_request.deliver_now!
		redirect_to root_path, notice: "Email Sent"
	end
end
