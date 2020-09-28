# frozen_string_literal: true

class DashboardController < ApplicationController
  before_action :set_user
  before_action :active_experiment_user, only: %i[overview experiments]
  before_action :active_experiment, only: %i[overview experiments]

  def overview; end

  def settings; end

  def progress
    @journal_entries = JournalEntry.per_user(current_user).select(
      :date, :mood, :sleep, :health, :relax, :connect, :meaning
    )
    @line_chart_data = %w[mood sleep health relax connect meaning].map do |category|
      {
        name: category.capitalize,
        data: @journal_entries.map do |journal_entry|
          [journal_entry.date, journal_entry.send(category)]
        end
      }
    end
  end

  def experiments
    @cancelled_experiments = Experiment.find(
      @user.experiment_users&.cancelled&.latest_first&.map(&:experiment_id)
    )
    @completed_experiments = Experiment.find(
      @user.experiment_users&.completed&.latest_first&.map(&:experiment_id)
    )
  end

  def admin
    @categories = Category.all.oldest_first
    @experiments = Experiment.all
    @users = User.all
    @benefits = Benefit.all
  end

  private

  def set_user
    @user = current_user
    authorize self
  end

  def active_experiment_user
    @active_experiment_user ||= ExperimentUser.find_by_id(@user.experiment_users&.active&.first)
  end

  def active_experiment
    @active_experiment = Experiment.find_by_id(@active_experiment_user&.experiment_id)
  end
end
