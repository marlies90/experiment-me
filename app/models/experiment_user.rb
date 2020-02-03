class ExperimentUser < ApplicationRecord
  belongs_to :user
  belongs_to :experiment

  validates_presence_of :user, :experiment, :status

  enum status: {
    active: 0,
    completed: 1,
    cancelled: 2
    }
end
