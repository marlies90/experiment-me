# frozen_string_literal: true

class AddObjectiveToExperiments < ActiveRecord::Migration[5.2]
  def change
    add_column :experiments, :objective, :text
  end
end
