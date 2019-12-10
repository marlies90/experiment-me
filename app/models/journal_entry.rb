class JournalEntry < ApplicationRecord
  belongs_to :user
  has_many :journal_ratings

  validates_presence_of :date, :user_id
  validates_uniqueness_of :date, scope: :user_id

  accepts_nested_attributes_for :journal_ratings
  validates_associated :journal_ratings

  scope :newest, -> { order("date DESC") }
end
