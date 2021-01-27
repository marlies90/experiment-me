# frozen_string_literal: true

require "rails_helper"

RSpec.describe Image, type: :model do
  subject { build(:image) }

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  it "is not valid without a name" do
    subject.name = nil
    expect(subject).to_not be_valid
  end

  it "is valid without an alt" do
    subject.alt = nil
    expect(subject).to be_valid
  end

  # it "is not valid without an image" do
  #   subject.image = nil
  #   expect(subject).to_not be_valid
  # end
end
