# frozen_string_literal: true

class Experiment < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  belongs_to :category
  has_many :resources, dependent: :destroy
  has_many :experiment_users
  has_many :users, through: :experiment_users
  has_many :experiment_benefits
  has_many :benefits, through: :experiment_benefits
  has_one_attached :image

  accepts_nested_attributes_for :resources,
                                allow_destroy: true,
                                reject_if: ->(attrs) { attrs["name"].blank? }

  validates_presence_of :name, :description, :category, :objective, :benefits

  scope :oldest_first, -> { order("created_at ASC") }
  scope :no_publish_date, -> { where(publish_date: nil) }
  scope :publish_date_has_passed, -> { where("publish_date < ?", Date.current) }
  scope :published, -> { no_publish_date.or(publish_date_has_passed) }
end
