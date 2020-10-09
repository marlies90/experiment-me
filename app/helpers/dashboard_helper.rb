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
    JournalEntry.where(user: current_user).find_by(date: date)
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

  def stat_by(start_date, end_date, categories)
    start_date ||= 21.days.ago
    end_date ||= Time.current
    line_chart filtered_api_progress_data_path(
      start_date: start_date, end_date: end_date, categories: categories
    ),
               legend: "top",
               xtitle: "Dates",
               ytitle: "Score",
               max: 5,
               curve: false,
               discrete: true,
               colors: [
                 "rgb(134,110,199)", "rgb(102,181,255)", "rgb(46,171,126)",
                 "rgb(224,174,67)", "rgb(209,55,53)", "rgb(52,58,64)"
               ],
               messages: { empty: "There is no data for this time period" }
  end
end
