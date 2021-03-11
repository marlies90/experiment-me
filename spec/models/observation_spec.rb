# frozen_string_literal: true

require "rails_helper"

RSpec.describe Observation, type: :model do
  subject { build(:observation) }
  let(:experiment) { build_stubbed(:experiment) }

  describe "associations" do
    it { is_expected.to respond_to(:user) }
    it { is_expected.to validate_presence_of(:user_id) }
    it { is_expected.to validate_presence_of(:date) }
    it { is_expected.to validate_presence_of(:mood) }
    it { is_expected.to validate_presence_of(:sleep) }
    it { is_expected.to validate_presence_of(:health) }
    it { is_expected.to validate_presence_of(:relax) }
    it { is_expected.to validate_presence_of(:connect) }
    it { is_expected.to validate_presence_of(:meaning) }
  end

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  it "is valid without experiment_id and experiment_success when there is no current experiment" do
    subject.experiment_id = nil
    subject.experiment_success = nil
    expect(subject).to be_valid
  end

  it "is not valid without experiment_success when there is a current experiment" do
    subject.experiment_id = experiment.id
    subject.experiment_success = nil

    expect(subject).to_not be_valid
  end

  it "is not valid without a date" do
    subject.date = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a user_id" do
    subject.user_id = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without filling in mood" do
    subject.mood = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without filling in sleep" do
    subject.sleep = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without filling in health" do
    subject.health = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without filling in relax" do
    subject.relax = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without filling in connect" do
    subject.connect = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without filling in meaning" do
    subject.meaning = nil
    expect(subject).to_not be_valid
  end

  it "is valid without a note" do
    subject.note = nil
    expect(subject).to be_valid
  end

  describe ".per_user" do
    let(:user) { FactoryBot.create(:user) }
    let(:observation_by_user) { FactoryBot.create(:observation, user: user) }

    it "includes observations created by a user" do
      expect(Observation.per_user(user)).to include observation_by_user
    end

    it "excludes observations created by a different user" do
      another_user = FactoryBot.create(:user)
      observation_by_another_user = FactoryBot.create(:observation, user: another_user)

      expect(Observation.per_user(user)).to_not include observation_by_another_user
    end
  end
end
