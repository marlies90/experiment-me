class ExperimentUsersController < ApplicationController
  before_action :set_experiment, only: [:new, :create, :update]
  before_action :set_experiment_user, only: [:update]

  def new
    if current_user
      @experiment_user = ExperimentUser.new
      authorize @experiment_user
    else
      redirect_to(new_user_session_path)
    end
  end

  def create
    @experiment_user = ExperimentUser.new(experiment_user_params)
    @experiment_user.user_id = current_user.id
    @experiment_user.active!

    if @experiment_user.save
      redirect_to dashboard_overview_path, notice: "Your have successfully started the experiment"
    else
      render :new
    end
  end

  def update
    @experiment_user.user_id = current_user.id

    if @journal_entry.update(experiment_user_params)
      redirect_to dashboard_overview_path, notice: "You have cancelled the experiment"
    else
      render :edit
    end
  end

  private

  def set_experiment
    @experiment = Experiment.friendly.find(params[:id])
  end

  def set_experiment_user
    @experiment_user = ExperimentUser.friendly.find(params[:id])
    authorize @experiment_user
  end

  def experiment_user_params
    params.fetch(:experiment_user).permit(
      :experiment_id, :user_id, :status
    )
  end
end
