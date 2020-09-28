# frozen_string_literal: true

class AddJournalRatingsToJournalEntry < ActiveRecord::Migration[6.0]
  def up
    add_column :journal_entries, :mood, :integer
    add_column :journal_entries, :sleep, :integer
    add_column :journal_entries, :health, :integer
    add_column :journal_entries, :relax, :integer
    add_column :journal_entries, :connect, :integer
    add_column :journal_entries, :meaning, :integer
  end

  def down
    remove_column :journal_entries, :mood, :integer
    remove_column :journal_entries, :sleep, :integer
    remove_column :journal_entries, :health, :integer
    remove_column :journal_entries, :relax, :integer
    remove_column :journal_entries, :connect, :integer
    remove_column :journal_entries, :meaning, :integer
  end
end
