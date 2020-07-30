# frozen_string_literal: true

class ExperimentUser < ApplicationRecord
  belongs_to :user
  belongs_to :experiment
  has_many :experiment_user_measurements

  validates_presence_of :user, :experiment, :status, :starting_date, :ending_date
  validates_presence_of :experiment_user_measurement, if: -> { experiment_user_measurement }
  validates_presence_of :difficulty, :life_impact, if: -> { completing_experiment }

  validate :cannot_have_multiple_active_experiments
  accepts_nested_attributes_for :experiment_user_measurements
  validates_associated :experiment_user_measurements, if: -> { experiment_user_measurement }

  scope :latest_first, -> { order("updated_at DESC") }

  enum status: {
    active: 0,
    completed: 1,
    cancelled: 2
  }

  DIFFICULTY_RATES = {
    0 => "Very easy",
    1 => "Easy",
    2 => "Moderate",
    3 => "Difficult",
    4 => "Very difficult"
  }.freeze

  LIFE_IMPACT_OPTIONS = {
    0 => "Very big",
    1 => "Big",
    2 => "Moderate",
    3 => "Small",
    4 => "Very small",
    5 => "No impact"
  }.freeze

  CANCELLATION_REASONS = {
    0 => "I accidentally started it",
    1 => "I have no time to focus on it right now",
    2 => "I no longer feel motivated to do this",
    3 => "I do not think it will have a positive impact on my life",
    4 => "Other"
  }.freeze

  private

  def experiment_user_measurement
    active? || completed?
  end

  def completing_experiment
    completed?
  end

  def cannot_have_multiple_active_experiments
    return unless active? && ExperimentUser.where(user_id: user, status: "active").present?

    errors.add(:experiment_user, ": you cannot have 2 active experiments at the same time")
  end
end
