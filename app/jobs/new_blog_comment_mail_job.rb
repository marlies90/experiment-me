# frozen_string_literal: true

class NewBlogCommentMailJob < ActiveJob::Base
  def perform
    new_blog_comments = BlogComment
                        .where(created_at: 24.hours.ago..DateTime.current)
                        .all
                        .to_a

    return if new_blog_comments.empty?

    AdminMailer.with(
      new_blog_comments: new_blog_comments
    ).new_blog_comment_email.deliver_later
  end
end
