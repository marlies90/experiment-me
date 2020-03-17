# frozen_string_literal: true

class AddSlugToJournalEntries < ActiveRecord::Migration[5.2]
  def change
    add_column :journal_entries, :slug, :string
    add_index :journal_entries, :slug
  end
end
