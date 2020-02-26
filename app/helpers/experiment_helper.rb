module ExperimentHelper
  def start_or_cancel_experiment
    if params[:status] == "cancelled"
      "Stop"
    else
      "Start"
    end
  end

  def already_doing_an_experiment
    ExperimentUser.find_by(user_id: current_user, status: "active").present?
  end

  def current_experiment
    experiment_user = ExperimentUser.find_by(user_id: current_user, status: "active")
    Experiment.find_by(id: experiment_user.experiment_id)
  end

  def active_experiment_on_date(date)
    return unless ExperimentUser.where(user_id: current_user)

    if @journal_entry.experiment_id.present?
      @active_experiment_on_date = Experiment.find_by(id: @journal_entry.experiment_id)
    else
      ExperimentUser.where(user_id: current_user).each do |user_experiment|
        next unless user_experiment.starting_date < date && user_experiment.ending_date > date
        @active_experiment_on_date = user_experiment.experiment
      end
    end

    @active_experiment_on_date
  end
end
