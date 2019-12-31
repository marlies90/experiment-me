class CreateJournalStatements < ActiveRecord::Migration[5.2]
  def change
    create_table :journal_statements do |t|
      t.text :name
      t.timestamps
    end
  end
end
