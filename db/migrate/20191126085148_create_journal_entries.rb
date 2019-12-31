class CreateJournalEntries < ActiveRecord::Migration[5.2]
  def change
    create_table :journal_entries do |t|
      t.datetime :date
      t.references :user, foreign_key: true, null: false

      t.timestamps
    end
  end
end
