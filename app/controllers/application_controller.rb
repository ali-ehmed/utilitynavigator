class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include ActionView::Helpers::TagHelper
  include ActionView::Context

  before_action :make_action_mailer_use_request_host_and_protocol

  helper_method :zip_code, :user_address

  protected

  def zip_code
    @zip_code ||= session[:user_zip_code]
  end

  def user_address
    @address ||= session[:user_address]
  end

  $broadband_providers = []

  private

  def make_action_mailer_use_request_host_and_protocol
    ActionMailer::Base.default_url_options[:protocol] = request.protocol
    ActionMailer::Base.default_url_options[:host] = request.host
  end
end
