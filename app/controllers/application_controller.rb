class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include ActionView::Helpers::TagHelper
  include ActionView::Context

  before_action :make_action_mailer_use_request_host_and_protocol
  # before_action :check_domain
  before_action :configure_permitted_parameters, if: :devise_controller?

  helper_method :zip_code, :user_address, :broadband_search

  def check_domain
    unless request.original_url.starts_with? "https://www"
      redirect_to "https://www.#{UtilityNavigator::Application.config.application_url}#{request.original_fullpath}" if Rails.env.production?
    end
  end

  # This method Excludes Unnecessary fields from requested params
  def exclude_garbage_fields(params)
    params.delete("checkout_select")
    params
    params.each do |key, value|
      if !value.is_a?(String) and value.is_a?(Hash)
        value.delete("checkout_select")
      end
    end

    params
  end

  protected

  %w(zip_code user_address broadband_search).each do |method_name|
    define_method(method_name) do
      name  = instance_variable_get("@#{method_name}")
      name ||= session[method_name.to_sym]
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) { |u|
      u.permit(:first_name, :last_name, :address,
              :zip_code, :cell_number, :date_of_birth,
              :home_number, :driver_license,
              :social_security, :four_digit_no,
              :email, :password, :password_confirmation,
              :current_password, :profile_image)
    }
  end

  private

  def make_action_mailer_use_request_host_and_protocol
    ActionMailer::Base.default_url_options[:protocol] = request.protocol
    ActionMailer::Base.default_url_options[:host] = request.host
  end
end
