# frozen_string_literal: true

class AddPracticalDetailsToExperiment < ActiveRecord::Migration[6.0]
  def up
    add_column :experiments, :practical_details, :text
  end

  def down
    remove_column :experiments, :practical_details
  end
end
