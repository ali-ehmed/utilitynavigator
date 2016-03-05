# == Schema Information
#
# Table name: payments
#
#  id                :integer          not null, primary key
#  user_id           :integer
#  package_id        :integer
#  extra_equiptments :string
#  card_last4        :string
#  card_exp_month    :integer
#  card_exp_year     :integer
#  card_type         :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  total_cost        :integer          default(0)
#

class PaymentsController < ApplicationController
	before_action :set_package, only: [:create]
	before_action :user_address, only: [:create]
  def create
  	@payment = @package.payments.build(payment_params)

  	extra_equiptments = @equiptment_params.select{|key, hash| hash == "true" }

  	extra_equiptments[:directory_name] = @directory_name if @package.provider.cox?
  	extra_equiptments[:transfer_phone_number] = @transfer_phone_number if @package.provider.charter?

  	@payment.extra_equiptments = extra_equiptments
  	@payment.total_cost = @equiptment_params[:total_cost]
  	
  	logger.debug @payment.inspect

  	if !@payment.valid?
  		errors = content_tag(:strong, "While creating user")
  		errors += @payment.errors.full_messages.map { |msg| content_tag(:li, msg) }.join.html_safe
  		flash.now[:alert] = errors
  		render @payment.render_payment_step and return
  	end

  	@payment.save
  	redirect_to root_path, notice: Payment::RESERVED_MESSAGE
  end

  private 

  def payment_params
  	params.require(:payment).permit(:package_id, :card_last4, :card_exp_month, :card_exp_year, 
  																	user_attributes: [:first_name, :last_name, :email, :address, 
  																										:zip_code, :cell_number, :date_of_birth, 
  																										:home_number, :driver_license, 
  																										:social_security, :four_digit_no])
  end

  def set_package
  	@package = Package.find(payment_params[:package_id])
  	@equiptment_params = session[:checkout_form_params]

  	@directory_name = @equiptment_params["directory_entered_name"] if @package.provider.cox?
  	@transfer_phone_number = @equiptment_params["transfer_phone_number"] if @package.provider.charter?
  end

  def user_address
  	@user_address = Array.new

  	unless cookies[:user_address].blank?
			@getting_user_address = eval(cookies[:user_address])
		else
			redirect_to root_path, flash: { alert: "Your session for booking order has expired." }
			return
		end

		@getting_user_address.map do |key, value|
			unless value.blank?
				@user_address << value
			end
		end
		

		@user_address = @user_address.join(", ")
  end
end
