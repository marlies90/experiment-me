# frozen_string_literal: true

require "rails_helper"

RSpec.describe InputTransformHelper, type: :helper do
  describe "#add_header_css_classes_blog" do
    blog_post_description = "<h2>hi</h2> some text <h3>a header</h3>"

    it "returns amount of days since start of the experiment and today" do
      expect(helper.add_header_css_classes_blog(blog_post_description)).to eq(
        "<h2 class='text-intense h3'>hi</h2> some text <h3 class='h4'>a header</h3>"
      )
    end
  end

  describe "#add_header_css_classes_experiment" do
    experiment_description = "<h3>the header</h3> and some content"

    it "returns amount of days since start of the experiment and today" do
      expect(helper.add_header_css_classes_experiment(experiment_description)).to eq(
        "<h3 class='text-intense h6'>the header</h3> and some content"
      )
    end
  end
end
