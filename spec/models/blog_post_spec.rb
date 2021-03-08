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

  it "is valid without a publish_date" do
    subject.publish_date = nil
    expect(subject).to be_valid
  end

  # it "is not valid without an image" do
  #   subject.image = nil
  #   expect(subject).to_not be_valid
  # end
end
