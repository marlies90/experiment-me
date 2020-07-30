# frozen_string_literal: true

class ChangeExperimentCompletionRatings < ActiveRecord::Migration[6.0]
  def up
    remove_column :experiment_users, :experiment_continuation
    add_column :experiment_users, :life_impact, :integer
    add_column :experiment_users, :ending_note, :text
  end

  def down
    add_column :experiment_users, :experiment_continuation, :integer
    remove_column :experiment_users, :life_impact
    remove_column :experiment_users, :ending_note
  end
end
