require 'rails_helper'

RSpec.describe ExperimentUserMeasurement, type: :model do
  let(:experiment_user) { FactoryBot.build(:experiment_user) }
  subject { build(:experiment_user_measurement, :with_starting_score, experiment_user: experiment_user) }

  describe "associations" do
    it { is_expected.to respond_to(:experiment_user) }
    it { is_expected.to respond_to(:benefit) }
    it { is_expected.to validate_presence_of(:experiment_user) }
    it { is_expected.to validate_presence_of(:benefit) }
  end

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  it "is not valid without an experiment_user" do
    subject.experiment_user = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a benefit" do
    subject.benefit = nil
    expect(subject).to_not be_valid
  end

  context "#starting_experiment" do
    context "when starting a new experiment" do
      it "is not valid without a starting_score" do
        subject.starting_score = nil
        expect(subject).to_not be_valid
      end

      it "is valid without an ending_score" do
        subject.ending_score = nil
        expect(subject).to be_valid
      end
    end

    context "when reactivating a cancelled experiment" do
      let(:cancelled_experiment) { FactoryBot.build(:experiment_user, :cancelled) }
      subject { build(:experiment_user_measurement, experiment_user: cancelled_experiment) }

      it "is not valid without a starting_score" do
        subject.starting_score = nil
        expect(subject).to_not be_valid
      end
    end
  end

  context "#ending_experiment" do
    let(:completed_experiment) { FactoryBot.build(:experiment_user, :completed) }
    subject { create(:experiment_user_measurement, :complete, experiment_user: completed_experiment) }

    context "when completing an experiment" do
      it "is not valid without an ending_score" do
        subject.ending_score = nil
        expect(subject).to_not be_valid
      end

      it "is valid without a starting_score" do
        subject.starting_score = nil
        expect(subject).to be_valid
      end
    end
  end
end
