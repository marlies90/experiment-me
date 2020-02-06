class DashboardController < ApplicationController
  before_action :set_user

  def overview
    @active_experiment = Experiment.find_by_id(@user.experiment_users&.active&.first&.experiment_id)
  end

  def settings
  end

  def progress
  end

  def experiments
    @active_experiment = Experiment.find_by_id(@user.experiment_users&.active&.first&.experiment_id)

    @cancelled_experiments = Experiment.find(@user.experiment_users&.cancelled.map(&:experiment_id))
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
