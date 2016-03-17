class CallBackController < ApplicationController
	def create
		@call_back = CallBack.new call_back_params

		logger.debug "#{@call_back.preferred_time}"
		# zone = ActiveSupport::TimeZone.new("Central Time (US & Canada)")
		# Time.now.in_time_zone(zone)

		if @call_back.save
			render :json => { status: :ok, msg: CallBack::SUCCESS }
		else
			render :json => { status: :error, errors: @call_back.errors.full_messages.map { |msg| content_tag(:li, msg) }.join }
		end
	end

	private

	def call_back_params
		params.require(:call_back).permit(:first_name, :time_zone, :last_name, :email, :phone_no, :address, :zip, :state, :preferred_time, :preferred_date)
	end
end