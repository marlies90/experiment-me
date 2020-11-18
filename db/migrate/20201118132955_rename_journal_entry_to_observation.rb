# frozen_string_literal: true

class RenameObservationToObservation < ActiveRecord::Migration[6.0]
  def change
    rename_table :observations, :observations
  end
end
