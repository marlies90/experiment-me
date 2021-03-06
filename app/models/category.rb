# frozen_string_literal: true

class Category < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  validates_presence_of :name, :description

  has_many :experiments
  has_one_attached :image

  scope :oldest_first, -> { order("id ASC") }
end
