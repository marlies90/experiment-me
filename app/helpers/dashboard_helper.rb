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

  def stat_by(start_date, end_date, categories)
    format_dates(start_date, end_date)

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

  def observations_by(start_date, end_date)
    format_dates(start_date, end_date)

    @selected_observations =
      Observation
      .includes(experiment: :category)
      .per_user(current_user)
      .where(date: @start_date..@end_date)
      .order(:date)
  end

  # rubocop:disable Metrics/AbcSize

  def observation_averages(start_date_experiment, end_date_experiment)
    calculate_averages_during_experiment(start_date_experiment, end_date_experiment)
    calculate_averages_before_experiment(
      start_date_experiment - 21.days,
      end_date_experiment - 22.days
    )
  end

  def compare_observation_averages(during, before)
    if during > before
      '<i class="text-health fas fa-arrow-up pr-0"></i>'.html_safe
    elsif during < before
      '<i class="text-connect fas fa-arrow-down pr-0"></i>'.html_safe
    else
      '<i class="fas fa-minus pr-0"></i>'.html_safe
    end
  end

  private

  def format_dates(start_date, end_date)
    format_start_date(start_date)
    format_end_date(end_date)
    @start_date, @end_date = @end_date, @start_date if @end_date < @start_date
  end

  def format_start_date(start_date)
    @start_date =
      if start_date
        start_date.to_datetime.midnight
      elsif params[:start_date].nil? || params[:start_date].empty?
        21.days.ago.midnight
      else
        params[:start_date].to_datetime.midnight
      end
  end

  def format_end_date(end_date)
    @end_date =
      if end_date
        end_date.to_datetime.at_end_of_day
      elsif params[:end_date].nil? || params[:end_date].empty?
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

  def calculate_averages_during_experiment(start_date_experiment, end_date_experiment)
    format_dates(start_date_experiment, end_date_experiment)

    observations_during_exp = Observation.per_user(current_user).where(date: @start_date..@end_date)
    @mood_during = observations_during_exp.average(:mood).to_f.round(2)
    @sleep_during = observations_during_exp.average(:sleep).to_f.round(2)
    @health_during = observations_during_exp.average(:health).to_f.round(2)
    @relax_during = observations_during_exp.average(:relax).to_f.round(2)
    @connect_during = observations_during_exp.average(:connect).to_f.round(2)
    @meaning_during = observations_during_exp.average(:meaning).to_f.round(2)
  end

  def calculate_averages_before_experiment(start_date_experiment, end_date_experiment)
    format_dates(start_date_experiment, end_date_experiment)

    observations_before_exp = Observation.per_user(current_user).where(date: @start_date..@end_date)
    @mood_before = observations_before_exp.average(:mood).to_f.round(2)
    @sleep_before = observations_before_exp.average(:sleep).to_f.round(2)
    @health_before = observations_before_exp.average(:health).to_f.round(2)
    @relax_before = observations_before_exp.average(:relax).to_f.round(2)
    @connect_before = observations_before_exp.average(:connect).to_f.round(2)
    @meaning_before = observations_before_exp.average(:meaning).to_f.round(2)
  end

  # rubocop:enable Metrics/AbcSize
end
