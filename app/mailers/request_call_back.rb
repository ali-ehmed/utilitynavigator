class RequestCallBack < ApplicationMailer
	default from: "no-reply@utilitynavigators.com"

  def call_request
    mail to: UtilityNavigator::Application.config.admin_notifications_email, subject: "Call Request"
  end
end
