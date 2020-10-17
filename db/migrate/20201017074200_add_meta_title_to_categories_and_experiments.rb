# frozen_string_literal: true

class AddMetaTitleToCategoriesAndExperiments < ActiveRecord::Migration[6.0]
  def up
    add_column :categories, :title, :text
    add_column :experiments, :title, :text
  end

  def down
    remove_column :categories, :title
    remove_column :experiments, :title
  end
end
