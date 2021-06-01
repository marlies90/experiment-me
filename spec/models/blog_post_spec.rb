# frozen_string_literal: true

require "rails_helper"

RSpec.describe BlogPost, type: :model do
  subject { build(:blog_post) }

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  it "is not valid without a name" do
    subject.name = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a description" do
    subject.description = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a summary" do
    subject.description = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a publish_date" do
    subject.publish_date = nil
    expect(subject).to_not be_valid
  end

  it "is valid without a meta_title" do
    subject.meta_title = nil
    expect(subject).to be_valid
  end

  it "is valid without a meta_description" do
    subject.meta_description = nil
    expect(subject).to be_valid
  end

  # it "is not valid without an image" do
  #   subject.image = nil
  #   expect(subject).to_not be_valid
  # end

  describe ".published" do
    context "with a publish_date in the past" do
      let(:blog_post) { FactoryBot.create(:blog_post) }

      it "includes the blog post in the scope" do
        expect(BlogPost.published).to include blog_post
      end
    end

    context "with a publish_date in the future" do
      let(:blog_post) { FactoryBot.create(:blog_post, publish_date: DateTime.current + 3) }

      it "excludes the blog post from the scope" do
        expect(BlogPost.published).not_to include blog_post
      end
    end
  end
end
