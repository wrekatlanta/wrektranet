class ApplicationController < ActionController::Base

  rescue_from DeviseLdapAuthenticatable::LdapException do |exception|
    render :text => exception, :status => 500
  end
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_action :configure_permitted_parameters, if: :devise_controller?
  protect_from_forgery with: :exception

  add_flash_types :error, :success, :info, :warning

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

  def authorize_exec
    current_user.authorize_exec!
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:first_name, :last_name, :display_name, :email, :phone) }
  end
end
