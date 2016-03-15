class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include ActionView::Helpers::TagHelper
  include ActionView::Context

  before_action :make_action_mailer_use_request_host_and_protocol

  helper_method :zip_code, :user_address, :broadband_search

  protected

  %w(zip_code user_address broadband_search).each do |method_name|
    define_method(method_name) do
      name  = instance_variable_get("@#{method_name}")
      name ||= session[method_name.to_sym]
    end
  end

  private

  def make_action_mailer_use_request_host_and_protocol
    ActionMailer::Base.default_url_options[:protocol] = request.protocol
    ActionMailer::Base.default_url_options[:host] = request.host
  end
end
