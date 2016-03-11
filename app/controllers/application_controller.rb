class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include ActionView::Helpers::TagHelper
  include ActionView::Context

  before_action :make_action_mailer_use_request_host_and_protocol

  def destroy_search_provider
    session[:broadband_providers] = nil  
  end

  private

  def make_action_mailer_use_request_host_and_protocol
    ActionMailer::Base.default_url_options[:protocol] = request.protocol
    ActionMailer::Base.default_url_options[:host] = request.host
  end
end
