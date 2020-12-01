# frozen_string_literal: true

class AddRecommendationToExperimentUser < ActiveRecord::Migration[6.0]
  def up
    add_column :experiment_users, :recommendation, :text
  end

  def down
    remove_column :experiment_users, :recommendation
  end
end
