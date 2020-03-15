class AddCompletionAttributesToExperimentUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :experiment_users, :difficulty, :integer
    add_column :experiment_users, :experiment_continuation, :integer
  end
end
