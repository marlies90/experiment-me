# frozen_string_literal: true

require "rails_helper"

RSpec.describe BlogComment, type: :model do
  subject { build(:blog_comment, :on_blog_post) }

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  it "is not valid without a name" do
    subject.author_name = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without an email" do
    subject.email = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a valid email" do
    subject.email = "notamailaddress"
    expect(subject).to_not be_valid
  end

  it "is not valid without a comment" do
    subject.comment = nil
    expect(subject).to_not be_valid
  end
end
