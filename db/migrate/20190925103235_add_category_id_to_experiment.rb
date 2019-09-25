class AddCategoryIdToExperiment < ActiveRecord::Migration[5.2]
  def change
    add_reference :experiments, :category, foreign_key: true
  end
end
