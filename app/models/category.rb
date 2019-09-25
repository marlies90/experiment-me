class Category < ApplicationRecord
  validates_presence_of :name, :description, :image

  has_many :experiments
end
