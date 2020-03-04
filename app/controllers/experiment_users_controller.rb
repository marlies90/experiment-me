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
    @experiment_user.starting_date = params[:experiment_user][:starting_date] || DateTime.current
    @experiment_user.ending_date = (@experiment_user.starting_date + 21.days).end_of_day

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

    if params[:experiment_user][:status] == "cancelled"
      @experiment_user.ending_date = DateTime.current

      if @experiment_user.update(experiment_user_params)
        redirect_to dashboard_experiments_path, notice: "You have cancelled the experiment"
      else
        redirect_to dashboard_experiments_path, notice: "Something went wrong when cancelling the experiment"
      end
    elsif params[:experiment_user][:status] == "active"
      @experiment_user.starting_date = DateTime.current
      @experiment_user.ending_date = (DateTime.current + 21).end_of_day

      if @experiment_user.update(experiment_user_params)
        redirect_to dashboard_experiments_path, notice: "You have reactivated the experiment"
      else
        redirect_to dashboard_experiments_path, notice: "Something went wrong when reactivating the experiment"
      end
    elsif params[:experiment_user][:status] == "completed"
      if @experiment_user.update(experiment_user_params)
        redirect_to dashboard_experiments_path, notice: "You have completed the experiment"
      else
        redirect_to dashboard_experiments_path, notice: "Something went wrong when completing the experiment"
      end
    end
  end

  private

  def set_experiment
    @experiment = Experiment.friendly.find(params[:experiment_id])
  end

  def experiment_user_params
    params.fetch(:experiment_user).permit(
      :experiment_id, :user_id, :status, :cancellation_reason
    )
  end
end
