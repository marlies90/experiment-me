# frozen_string_literal: true

class AddSlugToExperiments < ActiveRecord::Migration[5.2]
  def change
    add_column :experiments, :slug, :string
    add_index :experiments, :slug, unique: true
  end
end
