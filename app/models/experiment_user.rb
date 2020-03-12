class ExperimentUser < ApplicationRecord
  belongs_to :user
  belongs_to :experiment
  has_many :experiment_user_measurements

  validates_presence_of :user, :experiment, :status, :starting_date, :ending_date
  validates_presence_of :experiment_user_measurement, if: -> { experiment_user_measurement }

  validate :cannot_have_multiple_active_experiments
  accepts_nested_attributes_for :experiment_user_measurements

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

  def experiment_user_measurement
    active? || completed?
  end

  def cannot_have_multiple_active_experiments
    if active? && ExperimentUser.where(user_id: user, status: "active").present?
      errors.add(:experiment_user, ": you cannot have 2 active experiments at the same time")
    end
  end
end
