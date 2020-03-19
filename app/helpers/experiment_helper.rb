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
    @experiment_user&.id.blank? || @experiment_user.cancelled?
  end

  def completing_experiment
    @experiment_user&.id.present? && completed_experiment?(@experiment_user)
  end

  def cancelling_experiment
    @experiment_user&.id.present? && uncompleted_experiment?(@experiment_user)
  end

  def uncompleted_experiment?(experiment_user)
    experiment_user.ending_date > DateTime.current
  end

  def completed_experiment?(experiment_user)
    experiment_user.ending_date < DateTime.current
  end

  def already_doing_an_experiment
    ExperimentUser.find_by(user_id: current_user, status: "active").present?
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
