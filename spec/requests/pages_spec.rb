# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Pages", type: :request do
  describe "GET /" do
    it "returns the page successfully" do
      get root_path
      expect(response).to have_http_status(200)
    end
  end

  describe "Categories and experiments" do
    let(:category) { FactoryBot.create(:category) }

    describe "GET /categories" do
      it "returns the page successfully" do
        get categories_path
        expect(response).to have_http_status(200)
      end
    end

    describe "GET /:category/experiments" do
      it "returns the page successfully" do
        get category_show_path(category)
        expect(response).to have_http_status(200)
      end
    end

    describe "GET /:category/experiments/:id" do
      let(:experiment) { FactoryBot.create(:experiment, category: category) }

      it "returns the page successfully" do
        get experiment_path(id: experiment.slug, category: category)
        expect(response).to have_http_status(200)
      end
    end

    describe "GET /newest-experiment" do
      let!(:experiment) { FactoryBot.create(:experiment, category: category) }

      it "redirects to the newest experiment" do
        request = get newest_experiment_path
        expect(request).to redirect_to(experiment_path(id: experiment.slug, category: category))
      end
    end

    describe "GET /newest-blog_post" do
      let!(:blog_post) { FactoryBot.create(:blog_post) }

      it "redirects to the newest blog_post" do
        request = get newest_blog_post_path
        expect(request).to redirect_to(blog_post_path(blog_post))
      end
    end
  end
end
