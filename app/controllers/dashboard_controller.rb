# frozen_string_literal: true

class DashboardController < ApplicationController
  before_action :set_user
  before_action :active_experiment_user, only: %i[lab experiments]
  before_action :active_experiment, only: %i[lab experiments]

  def lab; end

  def settings; end

  def charts; end

  def experiments
    @cancelled_experiments = Experiment.find(
      @user.experiment_users&.cancelled&.map(&:experiment_id)
    )
    @completed_experiments = Experiment.find(
      @user.experiment_users&.completed&.map(&:experiment_id)
    )
  end

  def admin
    @categories = Category.all.oldest_first
    @experiments = Experiment.all
    @benefits = Benefit.all
    @blog_posts = BlogPost.all
    @blog_comments = BlogComment.all
    @images = Image.all
  end

  private

  def set_user
    @user = current_user
    authorize self
  end

  def active_experiment_user
    @active_experiment_user ||= ExperimentUser.find_by_id(@user.experiment_users&.active&.first)
  end

  def active_experiment
    @active_experiment = Experiment.find_by_id(@active_experiment_user&.experiment_id)
  end
end
