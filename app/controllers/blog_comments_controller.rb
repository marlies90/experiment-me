# frozen_string_literal: true

class BlogCommentsController < ApplicationController
  before_action :find_commentable, only: %i[create destroy]
  before_action :set_blog_comment, only: %i[destroy]
  invisible_captcha only: [:create], honeypot: :website

  def create
    @comment = BlogComment.new
    @commentable.blog_comments.build(blog_comment_params)

    if @commentable.save
      redirect_back(fallback_location: root_path, notice: "Your comment was successfully posted!")
    else
      render :new, locals: { commentable: @commentable }, alert: "Your comment wasn't posted!"
    end
  end

  def destroy
    @comment.destroy
    redirect_to dashboard_admin_path, notice: "Comment was successfully destroyed."
  end

  private

  def blog_comment_params
    params.require(:blog_comment).permit(:author_name, :email, :comment)
  end

  def find_commentable
    if params[:blog_comment_id]
      @commentable = BlogComment.find_by_id(params[:blog_comment_id])
    elsif params[:blog_post_id]
      @commentable = BlogPost.friendly.find(params[:blog_post_id])
    end
  end

  def set_blog_comment
    @comment = BlogComment.find(params[:id])
    authorize @comment
  end
end
