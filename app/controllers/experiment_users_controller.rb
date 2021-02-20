# frozen_string_literal: true

class ExperimentUsersController < ApplicationController
  before_action :experiment, only: %i[new edit show]
  before_action :set_user

  def show
    experiment_user
  end

  def new
    if current_user
      @experiment_user = ExperimentUser.new
      authorize @experiment_user

      experiment_user_measurements =
        ExperimentBenefit.where(experiment_id: @experiment.id).map do |experiment_benefit|
          ExperimentUserMeasurement.new(benefit_id: experiment_benefit.benefit_id)
        end

      @experiment_user.experiment_user_measurements = experiment_user_measurements
    else
      redirect_to(new_user_registration_path)
    end
  end

  def create
    @experiment = Experiment.friendly.find(params[:experiment_user][:experiment_id])
    @experiment_user = ExperimentUser.new(experiment_user_params)
    @experiment_user.user_id = current_user.id
    set_starting_experiment_user_attributes

    if @experiment_user.save
      redirect_to dashboard_experiments_path, notice: "You have successfully started the experiment"
      send_start_notifications("Creation")
    else
      render :new
    end
  end

  def edit
    experiment_user
  end

  def update
    @experiment = Experiment.friendly.find(params[:experiment_user][:experiment_id])
    experiment_user

    if @experiment_user.uncompleted_active_experiment
      cancel_experiment
    elsif @experiment_user.completed_active_experiment
      complete_experiment
    elsif @experiment_user.cancelled
      reactivate_experiment
    end
  end

  private

  def cancel_experiment
    @experiment_user.status = "cancelled"
    @experiment_user.ending_date = DateTime.current.beginning_of_day

    if @experiment_user.update(experiment_user_params)
      redirect_to dashboard_experiments_path, notice: "You have cancelled the experiment"
      send_google_analytics_event("Cancellation")
    else
      render :edit
    end
  end

  def complete_experiment
    @experiment_user.status = "completed"

    if @experiment_user.update(experiment_user_params)
      redirect_to dashboard_experiments_path, notice: "You have completed the experiment"
      send_google_analytics_event("Completion")
    else
      render :edit
    end
  end

  def reactivate_experiment
    set_starting_experiment_user_attributes

    if @experiment_user.update(experiment_user_params)
      redirect_to dashboard_experiments_path, notice: "You have reactivated the experiment"
      send_start_notifications("Reactivation")
    else
      render :edit
    end
  end

  def set_starting_experiment_user_attributes
    @experiment_user.starting_date = params[:experiment_user][:starting_date]
    @experiment_user.ending_date = (@experiment_user.starting_date + 21.days).end_of_day
    @experiment_user.status = "active"
  end

  def send_start_notifications(notification_type)
    send_experiment_user_start_mail
    send_google_analytics_event(notification_type)
  end

  def send_experiment_user_start_mail
    UserMailer.with(user: @user, experiment: @experiment).experiment_start_email.deliver_later
  rescue StandardError
    nil
  end

  def send_google_analytics_event(action)
    GoogleAnalyticsEvent.new(
      "Experiment user",
      action,
      @experiment.slug.to_s,
      params[:ga_client_id]
    ).event
  end

  def experiment_user
    @experiment_user ||= ExperimentUser.find_by(
      experiment_id: @experiment.id, user_id: current_user.id
    )
    authorize @experiment_user
  end

  def experiment
    @experiment ||= Experiment.friendly.find(params[:experiment_id])
  end

  def set_user
    @user = current_user
  end

  def experiment_user_params
    params.fetch(:experiment_user).permit(
      :experiment_id, :user_id, :status, :cancellation_reason, :starting_date, :difficulty,
      :life_impact, :ending_note, :recommendation,
      experiment_user_measurements_attributes: %i[id benefit_id starting_score ending_score]
    )
  end
end
