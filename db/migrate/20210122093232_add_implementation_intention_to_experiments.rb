# frozen_string_literal: true

class AddImplementationIntentionToExperiments < ActiveRecord::Migration[6.0]
  def up
    add_column :experiments, :implementation_intention, :text
  end

  def down
    remove_column :experiments, :implementation_intention
  end
end
