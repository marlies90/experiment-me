class AddDatesToExperimentUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :experiment_users, :starting_date, :datetime, null: false
    add_column :experiment_users, :ending_date, :datetime, null: false
  end
end
