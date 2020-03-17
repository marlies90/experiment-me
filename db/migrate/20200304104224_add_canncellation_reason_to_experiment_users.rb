# frozen_string_literal: true

class AddCanncellationReasonToExperimentUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :experiment_users, :cancellation_reason, :integer
  end
end
