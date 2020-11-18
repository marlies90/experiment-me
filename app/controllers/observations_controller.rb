# frozen_string_literal: true

class ObservationsController < ApplicationController
  before_action :set_user
  before_action :set_observation, only: %i[edit update destroy]
  helper_method :date

  def index
    create_date_list
    observation_dates
    @available_dates = (@dates - @observation_dates) | (@observation_dates - @dates)

    @active_experiment = Experiment.find_by_id(@user.experiment_users&.active&.first&.experiment_id)
  end

  def new
    @observation = Observation.new
  end

  def edit; end

  def create
    @observation = Observation.new(observation_params)
    @observation.user_id = current_user.id

    create_date_list

    if @observation.save
      redirect_to dashboard_progress_path, notice: "Your observation has been saved."
    else
      render :new
    end
  end

  def update
    @date = params[:observation][:date].to_datetime
    @observation.user_id = current_user.id

    if @observation.update(observation_params)
      redirect_to dashboard_progress_path, notice: "Your observation has been updated."
    else
      render :edit
    end
  end

  def destroy
    @observation.destroy
    redirect_to observations_path, notice: "Your observation has been deleted."
  end

  private

  def create_date_list
    @dates = []
    7.times do |index|
      @dates << DateTime.current.beginning_of_day - index.day
    end
  end

  def observation_dates
    @observation_dates =
      @user.observations.newest.limit(7).map(&:date).difference(@dates).map(&:to_datetime)
  end

  def set_user
    @user = current_user
    authorize self
  end

  def set_observation
    @observation = Observation
                   .includes(:user)
                   .per_user(current_user)
                   .find_by(slug: params[:id])
  end

  def date
    if @observation.date.present?
      @observation.date
    elsif params[:date].present?
      params[:date].to_datetime
    else
      params[:observation][:date].to_datetime
    end
  end

  def observation_params
    params.fetch(:observation).permit(
      :date, :user_id, :experiment_id, :experiment_success,
      :mood, :sleep, :health, :relax, :connect, :meaning, :note
    )
  end
end
