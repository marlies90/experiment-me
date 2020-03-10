class ExperimentUserMeasurement < ApplicationRecord
  belongs_to :experiment_user
  belongs_to :benefit

  validates_presence_of :experiment_user, :benefit
end
