class JournalRating < ApplicationRecord
  belongs_to :journal_entry
  belongs_to :journal_statement

  validates_presence_of :journal_statement_id, :score
end
