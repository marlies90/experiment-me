class ExperimentsController < ApplicationController
  before_action :set_experiment, only: [:show, :edit, :update, :destroy]

  def index
  end

  def show
  end

  def new
    @experiment = Experiment.new
    authorize @experiment
    3.times { @experiment.benefits.build }
  end

  def edit
    3.times { @experiment.benefits.build }
  end

  def create
    @experiment = Experiment.new(experiment_params)
    authorize @experiment

    if @experiment.save
      redirect_to dashboard_admin_path, notice: 'Experiment was successfully created.'
    else
      render :new
    end
  end

  def update
    if @experiment.update(experiment_params)
      redirect_to dashboard_admin_path, notice: 'Experiment was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @experiment.destroy
    redirect_to dashboard_admin_path, notice: 'Experiment was successfully destroyed.'
  end

  private

    def set_experiment
      @experiment = Experiment.friendly.find(params[:id])
      authorize @experiment
    end

    def experiment_params
      params.fetch(:experiment).permit(
        :name, :description, :image, :objective, :category_id,
        resources_attributes: [:id, :name, :source, :_destroy],
        benefits_attributes: [:name]
      )
    end
end
