# frozen_string_literal: true

require "rails_helper"

RSpec.describe Experiment, type: :model do
  subject { build(:experiment) }

  describe "associations" do
    it { is_expected.to respond_to(:category) }
    it { is_expected.to respond_to(:resources) }
    it { is_expected.to respond_to(:benefits) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:description) }
    # it { is_expected.to validate_presence_of(:image) }
    it { is_expected.to validate_presence_of(:category) }
    it { is_expected.to validate_presence_of(:objective) }
    it { is_expected.to validate_presence_of(:benefits) }
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

  it "is valid without a title" do
    subject.title = nil
    expect(subject).to be_valid
  end

  it "is valid without a description_meta" do
    subject.description_meta = nil
    expect(subject).to be_valid
  end

  it "is not valid without an objective" do
    subject.objective = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a corresponding category" do
    subject.category = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without corresponding benefits" do
    subject.benefits = []
    expect(subject).to_not be_valid
  end

  it "is valid without corresponding resources" do
    subject.resources = []
    expect(subject).to be_valid
  end

  it "is valid without practical_details" do
    subject.practical_details = nil
    expect(subject).to be_valid
  end
end
