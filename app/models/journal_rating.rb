class JournalRating < ApplicationRecord
  belongs_to :journal_entry
  has_one :journal_statement
end
