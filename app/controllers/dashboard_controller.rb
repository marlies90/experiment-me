class DashboardController < ApplicationController
  before_action :authorize_user

  def overview
  end

  def settings
  end

  def progress
  end

  def admin
  end

  private

  def authorize_user
    authorize self
  end
end
