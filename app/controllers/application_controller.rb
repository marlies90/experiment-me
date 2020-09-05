# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :configure_permitted_parameters, if: :devise_controller?
  around_action :time_zone, if: :current_user

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name time_zone terms_agreement])
    devise_parameter_sanitizer.permit(
      :account_update,
      keys: %i[email time_zone password password_confirmation current_password]
    )
  end

  private

  def time_zone(&block)
    Time.use_zone(current_user.time_zone, &block)
  end

  def user_not_authorized
    flash[:alert] = "You need to be logged in to continue."
    redirect_to(request.referrer || home_path)
  end
end
