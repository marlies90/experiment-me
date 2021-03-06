# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]
  invisible_captcha only: [:create], honeypot: :age, scope: :user
  after_action :send_welcome_email, only: [:create]
  after_action :send_google_analytics_event, only: [:create]
  after_action :set_mail_preferences, only: [:create]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  def edit
    @active_mail_preferences =
      MailPreference.per_user(current_user).where(status: :active).pluck(:id)
    super
  end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  def update_resource(resource, params)
    return super if params["password"]&.present?

    resource.update_without_password(params.except("current_password"))
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

  private

  def send_welcome_email
    UserMailer.with(user: @user).welcome_email.deliver_later
  rescue StandardError
    nil
  end

  def send_google_analytics_event
    GoogleAnalyticsEvent.new(
      "User",
      "Registration",
      "",
      params[:ga_client_id]
    ).event
  end

  def set_mail_preferences
    return unless @user.save

    MailPreference.mail_types.each_key do |mail_type|
      @user.mail_preferences.create(
        mail_type: mail_type,
        status: :active
      )
    end
  end
end
