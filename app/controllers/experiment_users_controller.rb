# frozen_string_literal: true

class ExperimentUsersController < ApplicationController
  before_action :set_experiment, only: %i[new edit]

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
      redirect_to(new_user_session_path)
    end
  end

  def create
    @experiment = Experiment.friendly.find(params[:experiment_user][:experiment_id])
    @experiment_user = ExperimentUser.new(experiment_user_params)
    @experiment_user.user_id = current_user.id
    @experiment_user.starting_date = params[:experiment_user][:starting_date] || DateTime.current
    @experiment_user.ending_date = (@experiment_user.starting_date + 21.days).end_of_day
    @experiment_user.status = "active"

    if @experiment_user.save
      redirect_to dashboard_overview_path, notice: "You have successfully started the experiment"
    else
      render :new
    end
  end

  def edit
    @experiment_user = ExperimentUser.find_by(
      experiment_id: @experiment.id, user_id: current_user.id
    )
    authorize @experiment_user
  end

  def update
    @experiment = Experiment.friendly.find(params[:experiment_user][:experiment_id])
    @experiment_user = ExperimentUser.find_by(
      experiment_id: @experiment.id, user_id: current_user.id
    )
    authorize @experiment_user

    if @experiment_user.ending_date > DateTime.current && @experiment_user.active?
      cancel_experiment

      if @experiment_user.update(experiment_user_params)
        redirect_to dashboard_experiments_path, notice: "You have cancelled the experiment"
      else
        render :edit
      end
    elsif @experiment_user.ending_date < DateTime.current && @experiment_user.active?
      complete_experiment

      if @experiment_user.update(experiment_user_params)
        redirect_to dashboard_experiments_path, notice: "You have completed the experiment"
      else
        render :edit
      end
    elsif @experiment_user.cancelled?
      reactivate_experiment

      if @experiment_user.update(experiment_user_params)
        redirect_to dashboard_experiments_path, notice: "You have reactivated the experiment"
      else
        render :edit
      end
    end
  end

  private

  def cancel_experiment
    @experiment_user.status = "cancelled"
    @experiment_user.ending_date = DateTime.current
  end

  def complete_experiment
    @experiment_user.status = "completed"
  end

  def reactivate_experiment
    @experiment_user.status = "active"
    @experiment_user.starting_date = DateTime.current
    @experiment_user.ending_date = (DateTime.current + 21).end_of_day
  end

  def set_experiment
    @experiment = Experiment.friendly.find(params[:experiment_id])
  end

  def experiment_user_params
    params.fetch(:experiment_user).permit(
      :experiment_id, :user_id, :status, :cancellation_reason, :starting_date, :difficulty,
      :experiment_continuation,
      experiment_user_measurements_attributes: %i[id benefit_id starting_score ending_score]
    )
  end
end
