class Experiment < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  belongs_to :category
  has_many :resources
  has_and_belongs_to_many :benefits

  accepts_nested_attributes_for :resources, reject_if: lambda { |attrs| attrs['name'].blank? }
  accepts_nested_attributes_for :benefits, reject_if: lambda { |attrs| attrs['name'].blank? }

  validates_presence_of :name, :description, :image, :objective
end
