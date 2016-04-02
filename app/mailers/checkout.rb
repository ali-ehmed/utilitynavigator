class Checkout < ApplicationMailer
	default from: "test@designhenge.com" 
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.checkout.notify_admin.subject
  #
  def notify_admin(order)
    @greeting = "Hi Admin"
    @order = order
    mail to: UtilityNavigator::Application.config.admin_notifications_email, subject: "New Order, Order ##{@order.id}"
  end

  def notify_user(order, user)
    @user = user
    @greeting = "Hi #{@user.full_name}"
    @order = order
    mail to: @user.email, subject: "Order successfully placed"
  end

  def pwd_instructions(user, pwd)
    @user = user
    @greeting = "Hi #{@user.full_name}"
    @pwd = pwd
    mail to: @user.email, subject: "Password Instructions"
  end

  def user_order_approval(order, user)
    @user = user
    @greeting = "Hi #{@user.full_name}"
    @order = order
    mail to: @user.email, subject: "Order Status"
  end
end
