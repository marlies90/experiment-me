# frozen_string_literal: true

class AddExperimentIdToResources < ActiveRecord::Migration[5.2]
  def change
    add_reference :resources, :experiment, foreign_key: true
  end
end
