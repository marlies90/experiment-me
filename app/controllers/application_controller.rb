# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include Pundit
  before_action :configure_permitted_parameters, if: :devise_controller?
  around_action :time_zone, if: :current_user

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name time_zone terms_agreement])
  end

  private

  def time_zone(&block)
    Time.use_zone(current_user.time_zone, &block)
  end
end
