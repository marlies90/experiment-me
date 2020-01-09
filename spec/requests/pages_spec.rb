require 'rails_helper'

RSpec.describe "Pages", type: :request do

  describe "GET /" do
    it "returns the page successfully" do
      get home_path
      expect(response).to have_http_status(200)
    end
  end

  describe "Categories and experiments" do
    let(:category) { create(:category) }

    describe "GET /categories" do
      it "returns the page successfully" do
        get categories_path
        expect(response).to have_http_status(200)
      end
    end

    describe "GET /:category/experiments" do
      it "returns the page successfully" do
        get category_path(category)
        expect(response).to have_http_status(200)
      end
    end

    describe "GET /:category/experiments/:id" do
      let(:experiment) { create(:experiment, category: category) }

      it "returns the page successfully" do
        get experiment_path(id: experiment.slug, category: category)
        expect(response).to have_http_status(200)
      end
    end
  end
end
