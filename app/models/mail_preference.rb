# frozen_string_literal: true

class MailPreference < ApplicationRecord
  belongs_to :user

  validates_presence_of :mail_type, :status, :user_id

  enum mail_type: {
    experiment_start: 1,
    experiment_midway: 2,
    experiment_end: 3
  }

  enum status: {
    inactive: 0,
    active: 1
  }

  MAIL_TYPE_DESCRIPTIONS = {
    "experiment_start" => "When I start an experiment",
    "experiment_midway" => "Halfway through my experiment",
    "experiment_end" => "When my experiment ends"
  }.freeze

  scope :per_user, ->(user) { where(user_id: user.id) }
end
