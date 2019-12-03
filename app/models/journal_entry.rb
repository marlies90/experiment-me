class JournalEntry < ApplicationRecord
  belongs_to :user
  has_many :journal_ratings

  validates_presence_of :date, :user_id

  accepts_nested_attributes_for :journal_ratings
end
