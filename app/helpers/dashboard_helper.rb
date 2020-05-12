# frozen_string_literal: true

module DashboardHelper
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def journal_entry_for_date(date)
    JournalEntry.includes(:journal_ratings).find_by(date: date)
  end

  def active_experiment_day_counter(active_experiment_user)
    (DateTime.current.beginning_of_day.to_date - active_experiment_user.starting_date.to_date).to_i
  end
end
