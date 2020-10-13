class AddMetaDescToCategoriesAndExperiments < ActiveRecord::Migration[6.0]
  def up
    add_column :categories, :description_meta, :text
    add_column :experiments, :description_meta, :text
  end

  def down
    remove_column :categories, :description_meta
    remove_column :experiments, :description_meta
  end
end
