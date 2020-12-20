# frozen_string_literal: true

class CreateBlogPosts < ActiveRecord::Migration[6.0]
  def change
    create_table :blog_posts do |t|
      t.string :name, null: false
      t.text :summary, null: false
      t.text :description, null: false
      t.text :image
      t.string :slug

      t.timestamps

      t.index :slug, unique: true
    end
  end
end
