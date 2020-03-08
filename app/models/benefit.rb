class Benefit < ApplicationRecord
  has_many :experiment_benefits
  has_many :experiments, through: :experiment_benefits

  validates_presence_of :name, :measurement_statement
end
