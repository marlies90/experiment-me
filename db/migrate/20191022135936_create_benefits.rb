class CreateBenefits < ActiveRecord::Migration[5.2]
  def change
    create_table :benefits do |t|
      t.string :name
      t.timestamps
    end

    create_table :benefits_experiments, id: false do |t|
      t.belongs_to :benefit
      t.belongs_to :experiment
    end
  end
end
