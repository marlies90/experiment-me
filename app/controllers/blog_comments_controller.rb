# frozen_string_literal: true

class BlogCommentsController < ApplicationController
  before_action :find_commentable, only: %i[create destroy]
  before_action :set_blog_comment, only: %i[destroy]
  before_action :set_blog_post, only: %i[create]
  invisible_captcha only: [:create], honeypot: :website

  def create
    @comment = @commentable.blog_comments.build(blog_comment_params)

    if @comment.save
      flash[:comment_notice] = "Your comment has been posted!"
    else
      flash[:comment_errors] = @comment.errors.full_messages
    end

    redirect_to blog_post_path(@blog_post) + "#comment_section_anchor"
  end

  def destroy
    @comment.destroy
    redirect_to dashboard_admin_path, notice: "Comment was successfully destroyed."
  end

  private

  def blog_comment_params
    params.require(:blog_comment).permit(:author_name, :email, :comment)
  end

  def blog_post_params
    params.require(:blog_comment).permit(:blog_post_id)
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

  def set_blog_post
    @blog_post = BlogPost.find(blog_post_params[:blog_post_id]).slug
  end
end
