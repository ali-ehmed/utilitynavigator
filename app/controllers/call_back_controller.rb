class CallBackController < ApplicationController
	def create
		@call_back = CallBack.new call_back_params

		if @call_back.save
			render :json => { status: :ok, msg: CallBack::SUCCESS }
		else
			render :json => { status: :error, errors: @call_back.errors.full_messages.map { |msg| content_tag(:li, msg) }.join }
		end
	end

	private

	def call_back_params
		params.require(:call_back).permit(:first_name, :last_name, :email, :phone_no, :addres, :zip, :state, :preferred_time)
	end
end