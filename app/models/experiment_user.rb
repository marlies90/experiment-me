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

  enum cancellation_reason: {
    "I accidentally started it": 0,
    "I have no time to focus on it right now": 1,
    "I no longer feel motivated to do this": 2,
    "I do not think it will have a positive impact on my life": 3,
    "Other": 4
  }

  private

  def cannot_have_multiple_active_experiments
    if active? && ExperimentUser.where(user_id: user, status: "active").present?
      errors.add(:experiment_user, ": you cannot have 2 active experiments at the same time")
    end
  end
end
