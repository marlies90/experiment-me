class DashboardController < ApplicationController
  before_action :set_user

  def overview
  end

  def settings
  end

  def progress
  end

  def admin
  end

  private

  def set_user
    @user = current_user
    authorize self
  end
end
