# frozen_string_literal: true

class Observation < ApplicationRecord
  extend FriendlyId
  friendly_id :date_slug, use: :slugged
  include DateConcern

  belongs_to :user

  validates_presence_of :date, :user_id, :mood, :sleep, :health, :relax, :connect, :meaning
  validates :experiment_success,
            inclusion: {
              in: [true, false],
              message: "Fill in whether you stuck to the experiment"
            },
            if: -> { active_experiment }
  validates_uniqueness_of :date, scope: :user_id

  scope :newest, -> { order("date DESC") }
  scope :per_user, ->(user) { where(user_id: user.id) }

  private

  def active_experiment
    experiment_id
  end
end
