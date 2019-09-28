class Experiment < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged
  
  validates_presence_of :name, :description, :image

  belongs_to :category
end
