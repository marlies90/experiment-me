# frozen_string_literal: true

class CreateExperimentUserMeasurements < ActiveRecord::Migration[5.2]
  def change
    create_table :experiment_user_measurements do |t|
      t.references :experiment_user, foreign_key: true
      t.references :benefit, foreign_key: true
      t.integer :starting_score
      t.integer :ending_score
    end
  end
end
