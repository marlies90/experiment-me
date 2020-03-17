# frozen_string_literal: true

class AddExperimentToJournalEntry < ActiveRecord::Migration[5.2]
  def change
    add_reference :journal_entries, :experiment, foreign_key: true
    add_column :journal_entries, :experiment_success, :boolean
  end
end
