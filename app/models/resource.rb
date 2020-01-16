class Resource < ApplicationRecord
  belongs_to :experiment

  validates_presence_of :name, :source, :experiment
end
