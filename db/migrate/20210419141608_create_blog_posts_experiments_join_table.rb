# frozen_string_literal: true

class CreateBlogPostsExperimentsJoinTable < ActiveRecord::Migration[6.1]
  def change
    create_join_table :blog_posts, :experiments do |t|
      t.index :blog_post_id
      t.index :experiment_id
    end
  end
end
