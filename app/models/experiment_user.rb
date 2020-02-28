class ExperimentUser < ApplicationRecord
  belongs_to :user
  belongs_to :experiment

  validates_presence_of :user, :experiment, :status, :starting_date, :ending_date
  validate :cannot_have_multiple_active_experiments

  enum status: {
    active: 0,
    completed: 1,
    cancelled: 2
    }

  private

  def cannot_have_multiple_active_experiments
    if active? && ExperimentUser.where(user_id: user, status: "active").present?
      errors.add(:experiment_user, ": you cannot have 2 active experiments at the same time")
    end
  end
end
