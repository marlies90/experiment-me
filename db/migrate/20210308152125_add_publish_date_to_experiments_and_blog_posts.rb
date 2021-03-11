# frozen_string_literal: true

class AddPublishDateToExperimentsAndBlogPosts < ActiveRecord::Migration[6.1]
  def up
    add_column :experiments, :publish_date, :date
    add_column :blog_posts, :publish_date, :date
  end

  def down
    remove_column :experiments, :publish_date
    remove_column :blog_posts, :publish_date
  end
end
