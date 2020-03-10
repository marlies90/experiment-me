require 'rails_helper'

RSpec.describe ExperimentUser, type: :model do
  subject { build(:experiment_user, :active) }

  describe "associations" do
    it { is_expected.to respond_to(:experiment) }
    it { is_expected.to respond_to(:user) }
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:experiment) }
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to validate_presence_of(:starting_date) }
    it { is_expected.to validate_presence_of(:ending_date) }
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

  it "is not valid without starting date" do
    subject.starting_date = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without ending date" do
    subject.ending_date = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without experiment_user_measurements" do
    subject.experiment_user_measurements = []
    expect(subject).to_not be_valid
  end

  context "#experiment_user_measurement" do
    context "when completing an experiment" do
      subject { build(:experiment_user, :completed) }

      it "validates presence of experiment_user_measurement" do
        subject.experiment_user_measurements = []
        expect(subject).to_not be_valid
      end
    end

    context "when cancelling an experiment" do
      subject { build(:experiment_user, :cancelled) }

      it "does not validate presence of experiment_user_measurement" do
        subject.experiment_user_measurements = []
        expect(subject).to be_valid
      end
    end
  end

  context "#cannot_have_multiple_active_experiments" do
    let(:another_active_experiment) { create(:experiment_user, :active) }

    it "does not allow 2 active experiments at the same time" do
      expect(another_active_experiment).to_not be_valid
    end
  end
end
