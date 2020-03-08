class ExperimentBenefit < ApplicationRecord
  belongs_to :experiment
  belongs_to :benefit

  validates_presence_of :experiment, :benefit
end
