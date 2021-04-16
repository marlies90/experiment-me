# frozen_string_literal: true

class DashboardController < ApplicationController
  before_action :set_user
  before_action :active_experiment_user, only: %i[lab experiments]

  def lab; end

  def settings; end

  def charts; end

  def experiments
    completed_experiments
    cancelled_experiments
  end

  def admin
    @categories = Category.all.oldest_first
    @experiments = Experiment.includes(:category).all.newest_first
    @benefits = Benefit.all
    @blog_posts = BlogPost.includes(:blog_comments).all.newest_first
    @blog_comments = BlogComment.includes(:commentable).all
    @images = Image.all
  end

  private

  def set_user
    @user = current_user
    authorize self
  end

  def active_experiment_user
    @active_experiment_user ||=
      ExperimentUser
      .includes(:user, experiment: %i[category benefits])
      .where(user_id: @user.id, status: :active)
      .first
  end

  def completed_experiments
    @completed_experiments =
      ExperimentUser
      .includes(:user, experiment: :category)
      .where(user_id: @user.id, status: :completed)
  end

  def cancelled_experiments
    @cancelled_experiments =
      ExperimentUser
      .includes(:user, experiment: :category)
      .where(user_id: @user.id, status: :cancelled)
  end
end
