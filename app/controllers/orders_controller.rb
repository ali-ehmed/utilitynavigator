class OrdersController < ApplicationController
	before_action :set_package, only: [:create]
	# before_action :user_address, only: [:create]

  def create
  	@order = @package.orders.build(order_params)

  	extra_equiptments = @equiptments.select{|key, hash| hash == "true" }

  	extra_equiptments[:directory_name] = @directory_name if @package.provider.cox?
  	extra_equiptments[:transfer_phone_number] = @transfer_phone_number if @package.provider.charter?
    extra_equiptments[:timings] = params[:timings]

  	@order.extra_equiptments = extra_equiptments
  	@order.total_cost = @equiptments[:total_cost].to_f

  	logger.debug @order.inspect

    email = current_user.try(:email) || order_params[:user_attributes][:email]

    @user = User.find_by(email: email)

    unless @user.blank?
      logger.debug "User exists"
      @order.user = @user
    end

  	if !@order.valid?
  		errors = content_tag(:strong, "Review Errors")
  		errors += @order.errors.full_messages.map { |msg| content_tag(:li, msg) }.join.html_safe
  		flash.now[:alert] = errors
  		render @order.render_order_step and return
  	end

  	@order.save
  	redirect_to root_path, notice: Order::RESERVED_MESSAGE
  end

  private

  def order_params
  	params.require(:order).permit(:package_id, :card_last4, :card_exp_month, :card_exp_year, :security_code, :pay_at_installation, :user_agreement,
  																	user_attributes: [:first_name, :last_name, :email, :address,
  																										:zip_code, :cell_number, :date_of_birth,
  																										:home_number, :driver_license,
  																										:social_security, :four_digit_no, :state_issue])
  end

  def set_package
  	@package = Package.find(order_params[:package_id])
  	@equiptments = session[:checkout_form_params]

  	@directory_name = @equiptments["directory_entered_name"] if @package.provider.cox?
  	@transfer_phone_number = @equiptments["transfer_phone_number"] if @package.provider.charter?
  end

  def address
    @user_address = session[:user_address] if session[:user_address]

    if @user_address.blank?
      redirect_to root_path, flash: { alert: "Your booking order session has expired." }
      return
    end
  end
end
