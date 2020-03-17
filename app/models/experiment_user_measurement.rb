# frozen_string_literal: true

class ExperimentUserMeasurement < ApplicationRecord
  belongs_to :experiment_user
  belongs_to :benefit

  validates_presence_of :experiment_user, :benefit
  validates_presence_of :starting_score, if: -> { starting_experiment }
  validates_presence_of :ending_score, if: -> { ending_experiment }

  private

  def starting_experiment
    experiment_user&.id.blank? || experiment_user.cancelled?
  end

  def ending_experiment
    experiment_user&.completed?
  end
end
