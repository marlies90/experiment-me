# frozen_string_literal: true

class JournalStatement < ApplicationRecord
  has_many :journal_ratings

  validates_presence_of :name
end
