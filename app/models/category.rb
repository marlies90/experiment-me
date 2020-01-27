class Category < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  validates_presence_of :name, :description, :image

  has_many :experiments
  has_one_attached :image
end
