class Experiment < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  belongs_to :category
  has_many :resources
  has_many :experiment_users
  has_many :users, through: :experiment_users
  has_many :experiment_benefits
  has_many :benefits, through: :experiment_benefits
  has_one_attached :image

  accepts_nested_attributes_for :resources, reject_if: lambda { |attrs| attrs['name'].blank? }

  validates_presence_of :name, :description, :category, :objective, :benefits
end
