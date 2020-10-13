# frozen_string_literal: true

require "rails_helper"

RSpec.describe Category, type: :model do
  subject { build(:category) }

  describe "associations" do
    it { is_expected.to respond_to(:experiments) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:description) }
    # it { is_expected.to validate_presence_of(:image) }
  end

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

  # it "is not valid without an image" do
  #   subject.image = nil
  #   expect(subject).to_not be_valid
  # end

  it "is valid without a description_meta" do
    subject.description_meta = nil
    expect(subject).to be_valid
  end
end
