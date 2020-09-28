# frozen_string_literal: true

namespace :journal_entries do
  desc "Move existing journal_ratings to journal_entries"
  task move_journal_entries: :environment do
    journal_ratings = JournalRating.all

    ActiveRecord::Base.transaction do
      journal_ratings.each do |journal_rating|
        journal_entry = JournalEntry.find_by_id(journal_rating.journal_entry_id)
        case journal_rating.journal_statement_id
        when 1
          journal_entry.mood = journal_rating.score
        when 2
          journal_entry.sleep = journal_rating.score
        when 3
          journal_entry.health = journal_rating.score
        when 4
          journal_entry.relax = journal_rating.score
        when 5
          journal_entry.connect = journal_rating.score
        when 6
          journal_entry.meaning = journal_rating.score
        end

        journal_entry.save!(validate: false)
      end
    end

    puts " All done now! Moved #{journal_ratings.count} journal_ratings"
  end
end
