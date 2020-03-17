# frozen_string_literal: true

class RenameBenefitExperimentTable < ActiveRecord::Migration[5.2]
  def change
    rename_table :benefits_experiments, :experiment_benefits
  end
end
