class Experiment < ApplicationRecord
  validates_presence_of :name, :description, :image

  belongs_to :category
end
