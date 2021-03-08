# frozen_string_literal: true

class MailPreferencesController < ApplicationController
  before_action :set_user
  before_action :set_mail_preference, only: %i[edit update]

  def edit; end

  def update
    if @mail_preference.update(mail_preference_params)
      redirect_to dashboard_settings_path, notice: "Your mail_preference has been updated."
    else
      render :edit
    end
  end

  private

  def set_user
    @user = current_user
    authorize self
  end

  def set_mail_preference
    @mail_preference = MailPreference.includes(:user).per_user(current_user).find_by(id: params[:id])
  end

  def mail_preference_params
    params.fetch(:mail_preference).permit(
      :user_id, :mail_type, :status
    )
  end
end
