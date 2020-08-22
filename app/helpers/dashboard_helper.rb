# frozen_string_literal: true

module DashboardHelper
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def resource_class
    User
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def journal_entry_for_date(date)
    JournalEntry.includes(:journal_ratings).where(user: current_user).find_by(date: date)
  end

  def active_experiment_day_counter(active_experiment_user)
    (
      (DateTime.current.beginning_of_day.to_date - active_experiment_user.starting_date.to_date) + 1
    ).to_i
  end

  def uncompleted_active_experiment?
    @active_experiment_user.present? && @active_experiment_user.uncompleted_active_experiment
  end

  def completed_active_experiment?
    @active_experiment_user.present? && @active_experiment_user.completed_active_experiment
  end
end
