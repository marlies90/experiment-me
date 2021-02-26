# frozen_string_literal: true

class CategoriesController < ApplicationController
  before_action :set_category, only: %i[edit update destroy]

  def index
    @categories = Category.all.oldest_first
  end

  def show
    @category = Category.friendly.find(params[:category])
    authorize @category
    @experiments = @category.experiments.with_attached_image.oldest_first
  end

  def new
    @category = Category.new
    authorize @category
  end

  def edit; end

  def create
    @category = Category.new(category_params)
    authorize @category

    if @category.save
      redirect_to dashboard_admin_path, notice: "Category was successfully created."
    else
      render :new
    end
  end

  def update
    if @category.update(category_params)
      redirect_to dashboard_admin_path, notice: "Category was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @category.destroy
    redirect_to dashboard_admin_path, notice: "Category was successfully destroyed."
  end

  private

  def set_category
    @category = Category.friendly.find(params[:id])
    authorize @category
  end

  def category_params
    params.fetch(:category).permit(:name, :description, :image, :description_meta, :title)
  end
end
