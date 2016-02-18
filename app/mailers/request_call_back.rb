class RequestCallBack < ApplicationMailer
	default from: "ali.ahmed.cs2014@gmail.com" 
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.request_call_back.call_request.subject
  #
  def call_request
    mail to: UtilityNavigator::Application.config.admin_notifications_email, subject: "Call Request"
  end
end
