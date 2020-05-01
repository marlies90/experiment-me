# frozen_string_literal: true

class AddCategoryToJournalStatements < ActiveRecord::Migration[5.2]
  def change
    add_column :journal_statements, :category, :string
  end
end
