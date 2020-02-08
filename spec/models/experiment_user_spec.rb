require 'rails_helper'

RSpec.describe ExperimentUser, type: :model do
  subject { build(:experiment_user, :active) }

  describe "associations" do
    it { is_expected.to respond_to(:experiment) }
    it { is_expected.to respond_to(:user) }
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:experiment) }
    it { is_expected.to validate_presence_of(:status) }
  end

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  it "is not valid without an experiment" do
    subject.experiment = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a user" do
    subject.user = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a status" do
    subject.status = nil
    expect(subject).to_not be_valid
  end
end
