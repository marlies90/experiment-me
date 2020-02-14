class ExperimentUsersController < ApplicationController
  before_action :set_experiment, only: [:new, :edit]

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
      redirect_to dashboard_overview_path, notice: "You have successfully started the experiment"
    else
      render :new
    end
  end

  def edit
    @experiment_user = ExperimentUser.find_by(experiment_id: @experiment.id, user_id: current_user.id)
    authorize @experiment_user
  end

  def update
    @experiment = Experiment.friendly.find(params[:experiment_user][:experiment_id])
    @experiment_user = ExperimentUser.find_by(experiment_id: @experiment.id, user_id: current_user.id)
    authorize @experiment_user

    if @experiment_user.update(experiment_user_params)
      if params[:experiment_user][:status] == "cancelled"
        redirect_to dashboard_experiments_path, notice: "You have cancelled the experiment"
      else
        redirect_to dashboard_experiments_path, notice: "You have reactivated the experiment"
      end
    else
      if params[:experiment_user][:status] == "cancelled"
        redirect_to dashboard_experiments_path, notice: "Something went wrong when cancelling the experiment"
      else
        redirect_to dashboard_experiments_path, notice: "Something went wrong when reactivating the experiment"
      end
    end
  end

  private

  def set_experiment
    @experiment = Experiment.friendly.find(params[:experiment_id])
  end

  def experiment_user_params
    params.fetch(:experiment_user).permit(
      :experiment_id, :user_id, :status
    )
  end
end
