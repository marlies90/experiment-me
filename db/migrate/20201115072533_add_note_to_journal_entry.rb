class AddNoteToJournalEntry < ActiveRecord::Migration[6.0]
  def up
    add_column :journal_entries, :note, :text
  end

  def down
    remove_column :journal_entries, :note
  end
end
