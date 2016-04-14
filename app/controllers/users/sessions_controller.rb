class Users::SessionsController < Devise::SessionsController
  # GET /resource/sign_in
  # before_action :require_account!, :except => [:new]
  # skip_before_action :require_account!
  # skip_before_filter :verify_authenticity_token, :only => :create
  # GET /resource/sign_in
  respond_to :json

  # def new
  #   self.resource = resource_class.new(sign_in_params)
  #   clean_up_passwords(resource)
  #   yield resource if block_given?
  #   render template: "landings/index"
  # end

  def create
    self.resource = warden.authenticate!(auth_options)
    flash[:notice] = "Logged in successfully"
    sign_in(resource_name, resource)
    yield resource if block_given?
    respond_to do |format|
      format.json { render :json => { location: dashboard_path } }
    end
  end

  def after_sign_in_path_for(resource)
    dashboard_path
  end
end