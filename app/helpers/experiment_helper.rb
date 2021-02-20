# frozen_string_literal: true

module ExperimentHelper
  def start_or_cancel_experiment
    if activating_experiment
      "Start"
    elsif cancelling_experiment
      "Stop"
    elsif completing_experiment
      "Evaluate"
    end
  end

  def activating_experiment
    @experiment_user&.id.blank? || @experiment_user.cancelled
  end

  def completing_experiment
    @experiment_user&.id.present? && @experiment_user.completed_active_experiment
  end

  def cancelling_experiment
    @experiment_user&.id.present? && @experiment_user.uncompleted_active_experiment
  end

  def already_doing_an_experiment
    current_experiment&.present?
  end

  def already_doing_this_experiment(experiment)
    current_experiment&.experiment_id == experiment.id
  end

  def already_did_this_experiment(experiment)
    completed_experiments_ids&.include?(experiment.id)
  end

  def active_experiment_on_date(date)
    return unless @current_user&.experiment_users&.any?

    @active_experiment_on_date = if @observation.experiment_id.present?
                                   Experiment.find_by(id: @observation.experiment_id)
                                 else
                                   ExperimentUser
                                     .where(user_id: current_user)
                                     .find_by("starting_date <= ? AND ending_date > ?", date, date)
                                       &.experiment
                                 end
  end

  def current_experiment
    @current_user&.experiment_users&.active&.first
  end

  def completed_experiments_ids
    @current_user&.experiment_users&.completed&.map(&:experiment_id)
  end

  def experiment_user(experiment)
    ExperimentUser.find_by(user: current_user, experiment: experiment)
  end
end
