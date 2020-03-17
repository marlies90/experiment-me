# frozen_string_literal: true

class CreateJournalRatings < ActiveRecord::Migration[5.2]
  def change
    create_table :journal_ratings do |t|
      t.references :journal_entry, foreign_key: true, null: false
      t.references :journal_statement, foreign_key: true, null: false
      t.integer :score, null: false

      t.timestamps
    end
  end
end
