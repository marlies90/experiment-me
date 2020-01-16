require 'rails_helper'

RSpec.describe Resource, type: :model do
  subject { build(:resource) }

  describe "associations" do
    it { is_expected.to respond_to(:experiment) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:source) }
    it { is_expected.to validate_presence_of(:experiment) }
  end

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  it "is not valid without a name" do
    subject.name = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a description" do
    subject.source = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a corresponding experiment" do
    subject.experiment = nil
    expect(subject).to_not be_valid
  end
end
