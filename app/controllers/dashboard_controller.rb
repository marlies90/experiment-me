class DashboardController < ApplicationController
  before_action :set_user

  def overview
    @active_experiment_for_user = Experiment.find(@user.experiment_users.active.first.experiment_id)
  end

  def settings
  end

  def progress
  end

  def admin
    @categories = Category.all
    @experiments = Experiment.all
    @journal_statements = JournalStatement.all
    @users = User.all
  end

  private

  def set_user
    @user = current_user
    authorize self
  end
end
