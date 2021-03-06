# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from Net::SMTPAuthenticationError do
    logger.error("SMTPAuthenticationError: couldn't send email")
    redirect_back(fallback_location: root_url, alert: "Error: email could not be sent")
  end

  before_action :configure_permitted_parameters, if: :devise_controller?
  around_action :time_zone, if: :current_user

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name time_zone terms_agreement])
    devise_parameter_sanitizer.permit(
      :account_update,
      keys: [
        :first_name,
        :email,
        :time_zone,
        :password,
        :password_confirmation,
        :current_password,
        mail_preferences_attributes: %i[
          id status
        ]
      ]
    )
  end

  def after_sign_in_path_for(_resource)
    dashboard_lab_path
  end

  private

  def time_zone(&block)
    Time.use_zone(current_user.time_zone, &block)
  end

  def user_not_authorized
    flash[:alert] = "You need to be logged in to continue."
    redirect_to(new_user_session_path)
  end
end
