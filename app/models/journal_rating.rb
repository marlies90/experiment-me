class JournalRating < ApplicationRecord
  belongs_to :journal_entry
  belongs_to :journal_statement

  validates_presence_of :journal_statement, :journal_entry, :score
end
