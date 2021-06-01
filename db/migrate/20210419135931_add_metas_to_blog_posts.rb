# frozen_string_literal: true

class AddMetasToBlogPosts < ActiveRecord::Migration[6.1]
  def up
    add_column :blog_posts, :meta_title, :text
    add_column :blog_posts, :meta_description, :text
  end

  def down
    remove_column :blog_posts, :meta_title
    remove_column :blog_posts, :meta_description
  end
end
