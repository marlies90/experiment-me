# frozen_string_literal: true

class BlogPostsController < ApplicationController
  before_action :set_blog_post, only: %i[show edit update destroy]

  def index
    @blog_posts = BlogPost.published.newest_first
  end

  def show; end

  def new
    @blog_post = BlogPost.new
    authorize @blog_post
  end

  def edit; end

  def create
    @blog_post = BlogPost.new(blog_post_params)
    authorize @blog_post

    if @blog_post.save
      redirect_to dashboard_admin_path, notice: "Blog post was successfully created."
    else
      render :new
    end
  end

  def update
    if @blog_post.update(blog_post_params)
      redirect_to dashboard_admin_path, notice: "Blog post was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @blog_post.destroy
    redirect_to dashboard_admin_path, notice: "Blog post was successfully destroyed."
  end

  private

  def set_blog_post
    @blog_post = BlogPost.friendly.find(params[:id])
    authorize @blog_post
  end

  def blog_post_params
    params.fetch(:blog_post).permit(
      :name, :summary, :description, :image, :publish_date, :meta_title, :meta_description,
      experiment_ids: []
    )
  end
end
