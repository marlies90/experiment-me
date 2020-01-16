class Benefit < ApplicationRecord
  has_and_belongs_to_many :experiments

  validates_presence_of :name
end
