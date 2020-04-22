# frozen_string_literal: true

class RemoveImageFromCategories < ActiveRecord::Migration[5.2]
  def change
    remove_column :categories, :image, :text
  end
end
