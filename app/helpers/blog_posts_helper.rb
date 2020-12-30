# frozen_string_literal: true

module BlogPostsHelper
  def number_of_comments
    number_of_blog_comments = @blog_post.blog_comments.size

    number_of_replies = 0
    @blog_post.blog_comments.each do |blog_comment|
      number_of_replies += blog_comment.blog_comments.size
    end

    number_of_blog_comments + number_of_replies
  end
end
