# frozen_string_literal: true

class BlogCommentsController < ApplicationController
  before_action :find_commentable, only: :create
  invisible_captcha only: [:create], honeypot: :website

  def create
    @comment = BlogComment.new
    @commentable.blog_comments.build(blog_comment_params)

    if @commentable.save
      redirect_back(fallback_location: root_path, notice: "Your comment was successfully posted!")
    else
      redirect_back(fallback_location: root_path, alert: "Your comment wasn't posted!")
    end
  end

  def blog_comment_params
    params.require(:blog_comment).permit(:author_name, :email, :comment)
  end

  private

  def find_commentable
    if params[:blog_comment_id]
      @commentable = BlogComment.find_by_id(params[:blog_comment_id])
    elsif params[:blog_post_id]
      @commentable = BlogPost.friendly.find(params[:blog_post_id])
    end
  end
end
