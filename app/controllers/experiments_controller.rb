# frozen_string_literal: true

class ExperimentsController < ApplicationController
  before_action :set_experiment, only: %i[show edit update destroy]

  def index; end

  def show
    @existing_experiment_user = ExperimentUser.find_by(
      experiment_id: @experiment.id, user_id: current_user&.id
    )
  end

  def new
    @experiment = Experiment.new
    authorize @experiment
  end

  def edit; end

  def create
    @experiment = Experiment.new(experiment_params)
    authorize @experiment

    if @experiment.save
      redirect_to dashboard_admin_path, notice: "Experiment was successfully created."
    else
      render :new
    end
  end

  def update
    if @experiment.update(experiment_params)
      redirect_to dashboard_admin_path, notice: "Experiment was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @experiment.destroy
    redirect_to dashboard_admin_path, notice: "Experiment was successfully destroyed."
  end

  private

  def set_experiment
    @experiment = Experiment.friendly.find(params[:id])
    authorize @experiment
  end

  def experiment_params
    params.fetch(:experiment).permit(
      :name, :description, :image, :objective, :category_id, :description_meta, :title,
      :practical_details, :implementation_intention,
      resources_attributes: %i[id name source _destroy],
      benefit_ids: []
    )
  end
end
