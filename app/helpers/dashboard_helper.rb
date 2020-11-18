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

  def observation_for_date(date)
    Observation.where(user: current_user).find_by(date: date)
  end

  def active_experiment_day_counter(active_experiment_user)
    (
      (DateTime.current.beginning_of_day.to_date - active_experiment_user.starting_date.to_date) + 1
    ).to_i
  end

  def calculate_streak
    return 0 if current_user&.observations.nil?

    streak_count = 0
    today = Date.current

    observation_array

    observation_array.reduce(today) do |memo, date|
      return streak_count || 0 if memo&.yesterday.nil?

      yesterday = memo.yesterday
      if date == yesterday || date == today
        streak_count += 1
        date
      end
    end

    streak_count
  end

  def uncompleted_active_experiment?
    @active_experiment_user.present? && @active_experiment_user.uncompleted_active_experiment
  end

  def completed_active_experiment?
    @active_experiment_user.present? && @active_experiment_user.completed_active_experiment
  end

  def stat_by(_start_date, _end_date, categories)
    format_dates

    line_chart filtered_api_progress_data_path(
      start_date: @start_date, end_date: @end_date, categories: categories
    ),
               legend: "top",
               xtitle: "Dates",
               ytitle: "Score",
               max: 5,
               curve: false,
               discrete: true,
               colors: [
                 "rgb(134,110,199)", "rgb(102,181,255)", "rgb(46,171,126)",
                 "rgb(200,140,47)", "rgb(170,35,33)", "rgb(128,128,128)"
               ],
               messages: { empty: "There is no data for this time period" }
  end

  def observations_by(_start_date, _end_date)
    format_dates

    @selected_observations =
      Observation.per_user(current_user).where(date: @start_date..@end_date).order(:date).all
  end

  def observation_experiment(observation)
    Experiment.find_by_id(observation&.experiment_id)
  end

  private

  def format_dates
    format_start_date
    format_end_date
    @start_date, @end_date = @end_date, @start_date if @end_date < @start_date
  end

  def format_start_date
    @start_date =
      if params[:start_date].nil? || params[:start_date].empty?
        21.days.ago.midnight
      else
        params[:start_date].to_datetime.midnight
      end
  end

  def format_end_date
    @end_date =
      if params[:end_date].nil? || params[:end_date].empty?
        Time.current.at_end_of_day
      else
        params[:end_date].to_datetime.at_end_of_day
      end
  end

  def observation_array
    current_user.observations.newest.map do |observation|
      observation.date.to_date
    end
  end
end
