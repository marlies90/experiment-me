# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/admin_mailer
class AdminMailerPreview < ActionMailer::Preview
  def new_blog_comment_mail
    AdminMailer.with(
      new_blog_comments: BlogComment.last(4)
    ).new_blog_comment_email
  end
end
