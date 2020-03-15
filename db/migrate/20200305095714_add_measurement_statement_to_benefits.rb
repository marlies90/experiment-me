class AddMeasurementStatementToBenefits < ActiveRecord::Migration[5.2]
  def change
    add_column :benefits, :measurement_statement, :text
  end
end
