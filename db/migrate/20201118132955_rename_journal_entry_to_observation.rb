# frozen_string_literal: true

class RenameJournalEntryToObservation < ActiveRecord::Migration[6.0]
  def change
    rename_table :journal_entries, :observations
  end
end
