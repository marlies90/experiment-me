# frozen_string_literal: true

class PagesController < ApplicationController
  def home; end

  def about; end

  def privacy_statement; end

  def terms_conditions; end

  def contact; end

  def newest_blog_post
    newest_blog_post = BlogPost.publish_date_has_passed.order("publish_date DESC").first
    redirect_to blog_post_path(newest_blog_post)
  end

  def newest_experiment
    newest_experiment = Experiment.publish_date_has_passed.order("publish_date DESC").first
    redirect_to experiment_path(id: newest_experiment.slug, category: newest_experiment.category)
  end
end
