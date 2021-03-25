# frozen_string_literal: true

class AdminMailer < ApplicationMailer
  def new_blog_comment_email
    @new_blog_comments = params[:new_blog_comments]
    mail(to: "info@experiment.rocks", subject: "New blog comment(s)")
  end
end
