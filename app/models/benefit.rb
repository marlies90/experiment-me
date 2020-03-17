# frozen_string_literal: true

class Benefit < ApplicationRecord
  has_many :experiment_benefits
  has_many :experiments, through: :experiment_benefits
  has_many :experiment_user_measurements

  validates_presence_of :name, :measurement_statement
end
