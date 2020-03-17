# frozen_string_literal: true

require "rails_helper"

RSpec.describe Benefit, type: :model do
  subject { build(:benefit) }

  describe "associations" do
    it { is_expected.to respond_to(:experiments) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:measurement_statement) }
  end

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  it "is not valid without a name" do
    subject.name = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a name" do
    subject.measurement_statement = nil
    expect(subject).to_not be_valid
  end
end
