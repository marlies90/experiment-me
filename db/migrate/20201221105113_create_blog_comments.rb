# frozen_string_literal: true

class CreateBlogComments < ActiveRecord::Migration[6.0]
  def change
    create_table :blog_comments do |t|
      t.string :author_name, null: false
      t.string :email, null: false
      t.text :comment, null: false
      t.references :commentable, polymorphic: true

      t.timestamps
    end
  end
end
