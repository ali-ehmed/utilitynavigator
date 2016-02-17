class RequestCallBack < ApplicationMailer
	default from: "test@designhenge.com" 
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.request_call_back.call_request.subject
  #
  def call_request
    mail to: AdminUser.email_address, subject: "Call Request"
  end
end
