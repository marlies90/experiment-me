class JournalEntry < ApplicationRecord
  belongs_to :user
  has_many :journal_ratings
end
