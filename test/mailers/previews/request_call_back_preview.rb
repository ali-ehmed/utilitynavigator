# Preview all emails at http://localhost:3000/rails/mailers/request_call_back
class RequestCallBackPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/request_call_back/call_request
  def call_request
    RequestCallBack.call_request
  end

end
