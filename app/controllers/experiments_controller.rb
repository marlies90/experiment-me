class ExperimentsController < ApplicationController
  before_action :set_experiment, only: [:show, :edit, :update, :destroy]

  def index
    @experiments = Experiment.all
  end

  def show
  end

  def new
    @experiment = Experiment.new
  end

  def edit
  end

  def create
    @experiment = Experiment.new(experiment_params)

    if @experiment.save
      redirect_to @experiment, notice: 'Experiment was successfully created.'
    else
      render :new
    end
  end

  def update
    if @experiment.update(experiment_params)
      redirect_to @experiment, notice: 'Experiment was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @experiment.destroy
    redirect_to experiments_url, notice: 'Experiment was successfully destroyed.'
  end

  private

    def set_experiment
      @experiment = Experiment.find(params[:id])
    end

    def experiment_params
      params.fetch(:experiment).permit(:name, :description, :image)
    end
end
