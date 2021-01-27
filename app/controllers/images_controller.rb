# frozen_string_literal: true

class ImagesController < ApplicationController
  before_action :set_image, only: %i[edit update destroy]

  def new
    @image = Image.new
    authorize @image
  end

  def edit; end

  def create
    @image = Image.new(image_params)
    authorize @image

    if @image.save
      redirect_to dashboard_admin_path, notice: "Image was successfully created."
    else
      render :edit
    end
  end

  def update
    if @image.update(image_params)
      redirect_to dashboard_admin_path, notice: "Image was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @image.destroy
    redirect_to dashboard_admin_path, notice: "Image was successfully destroyed."
  end

  private

  def set_image
    @image = Image.find(params[:id])
    authorize @image
  end

  def image_params
    params.fetch(:image).permit(:name, :alt, :image)
  end
end
