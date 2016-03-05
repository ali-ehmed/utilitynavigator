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
    mail to: UtilityNavigator::Application.config.admin_notifications_email.first, subject: "New Order, Order ##{@order.id}"
  end
end
