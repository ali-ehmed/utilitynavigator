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
#  total_cost        :float            default(0.0)
#  status            :integer          default(0)
#

class PaymentsController < ApplicationController
	before_action :set_package, only: [:create]
	# before_action :user_address, only: [:create]
  
  def create
  	@payment = @package.payments.build(payment_params)

  	extra_equiptments = @equiptment_params.select{|key, hash| hash == "true" }

  	extra_equiptments[:directory_name] = @directory_name if @package.provider.cox?
  	extra_equiptments[:transfer_phone_number] = @transfer_phone_number if @package.provider.charter?

  	@payment.extra_equiptments = extra_equiptments
  	@payment.total_cost = @equiptment_params[:total_cost].to_f
  	
  	logger.debug @payment.inspect

    email = current_user.try(:email) || payment_params[:user_attributes][:email]

    @user = User.find_by(email: email)

    unless @user.blank?
      logger.debug "User exists"
      @payment.user = @user
    end

  	if !@payment.valid?
  		errors = content_tag(:strong, "Review Errors")
  		errors += @payment.errors.full_messages.map { |msg| content_tag(:li, msg) }.join.html_safe
  		flash.now[:alert] = errors
  		render @payment.render_payment_step and return
  	end

  	@payment.save
  	redirect_to root_path, notice: Payment::RESERVED_MESSAGE
  end

  private 

  def payment_params
  	params.require(:payment).permit(:package_id, :card_last4, :card_exp_month, :card_exp_year, :security_code, :pay_at_installation, 
  																	user_attributes: [:first_name, :last_name, :email, :address, 
  																										:zip_code, :cell_number, :date_of_birth, 
  																										:home_number, :driver_license, 
  																										:social_security, :four_digit_no, :state_issue])
  end

  def set_package
  	@package = Package.find(payment_params[:package_id])
  	@equiptment_params = session[:checkout_form_params]

  	@directory_name = @equiptment_params["directory_entered_name"] if @package.provider.cox?
  	@transfer_phone_number = @equiptment_params["transfer_phone_number"] if @package.provider.charter?
  end

  def address
    @user_address = session[:user_address] if session[:user_address]

    if @user_address.blank?
      redirect_to root_path, flash: { alert: "Your session for booking order has expired." }
      return
    end

    # @zip_code = Address.get_zip_code(@user_address)
  end
end
