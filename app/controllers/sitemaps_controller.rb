# frozen_string_literal: true

class SitemapsController < ApplicationController
  def index
    @host = "#{request.protocol}#{request.host}"
    @categories = Category.all
    @experiments = Experiment.all
    @blog_posts = BlogPost.all
  end
end
