# frozen_string_literal: true

class CreateExperimentUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :experiment_users do |t|
      t.references :user, foreign_key: true, null: false
      t.references :experiment, foreign_key: true, null: false
      t.integer :status, null: false

      t.timestamps
    end

    add_index :experiment_users, %i[user_id experiment_id], unique: true
  end
end
