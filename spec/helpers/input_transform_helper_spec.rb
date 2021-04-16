# frozen_string_literal: true

require "rails_helper"

RSpec.describe InputTransformHelper, type: :helper do
  describe "#transform_blog_input" do
    it "returns the transformed headers" do
      blog_post_description = "<h2>hi</h2> some text <h3>a header</h3>"
      expect(helper.transform_blog_input(blog_post_description)).to eq(
        "<h2 class='text-intense h3'>hi</h2> some text <h3 class='h4'>a header</h3>"
      )
    end

    it "returns the transformed figcaption" do
      blog_post_description = "<figcaption>This is nice</figcaption>"
      expect(helper.transform_blog_input(blog_post_description)).to eq(
        "<figcaption class='figure-caption text-center'>This is nice</figcaption>"
      )
    end
  end

  describe "#add_header_css_classes_experiment" do
    experiment_description = "<h3>the header</h3> and some content"

    it "returns amount of days since start of the experiment and today" do
      expect(helper.add_header_css_classes_experiment(experiment_description)).to eq(
        "<h3 class='text-intense h5'>the header</h3> and some content"
      )
    end
  end
end
