# frozen_string_literal: true

class RemoveJournalStatementsAndRatings < ActiveRecord::Migration[6.0]
  def change
    drop_table :journal_ratings do |t|
      t.bigint "journal_entry_id", null: false
      t.bigint "journal_statement_id", null: false
      t.integer "score", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end

    drop_table :journal_statements do |t|
      t.text "name"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.string "category"
    end
  end
end
