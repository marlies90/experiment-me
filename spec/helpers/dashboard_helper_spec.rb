# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationHelper, type: :helper do
  describe "#active_experiment_day_counter" do
    let(:experiment_user) do
      FactoryBot.create(:experiment_user, :active, starting_date: 3.days.ago)
    end

    it "returns amount of days since start of the experiment and today" do
      expect(helper.active_experiment_day_counter(experiment_user)).to eq(4)
    end
  end

  describe "#observation_for_date" do
    describe "when a observation exists for a user" do
      before { allow(helper).to receive(:current_user).and_return(user_one) }

      let(:user_one) { FactoryBot.create(:user) }
      let(:today) { DateTime.current.beginning_of_day }
      let!(:observation_user_one) do
        FactoryBot.create(:observation, user: user_one, date: today)
      end

      it "returns the correct observation for the date given" do
        expect(helper.observation_for_date(today)).to eq(observation_user_one)
      end
    end

    describe "when an observation exists for a different user" do
      before { allow(helper).to receive(:current_user).and_return(user_one) }

      let(:user_one) { FactoryBot.create(:user) }
      let(:user_two) { FactoryBot.create(:user) }
      let(:today) { DateTime.current.beginning_of_day }
      let!(:observation_user_two) do
        FactoryBot.create(:observation, user: user_two, date: today)
      end

      it "does not return that observation" do
        expect(helper.observation_for_date(today)).to be_nil
      end
    end
  end

  describe "#calculate_streak" do
    let(:user) { FactoryBot.create(:user) }
    before { allow(helper).to receive(:current_user).and_return(user) }

    describe "when there is no observation for yesterday" do
      let!(:observation) do
        FactoryBot.create(
          :observation,
          date: DateTime.current - 2.days,
          user: user
        )
      end

      it "returns 0" do
        expect(helper.calculate_streak).to eq(0)
      end
    end

    describe "when there is an observation for yesterday" do
      let!(:observation) do
        FactoryBot.create(
          :observation,
          date: DateTime.current - 1.day,
          user: user
        )
      end

      it "returns 1" do
        expect(helper.calculate_streak).to eq(1)
      end
    end

    describe "when there are 3 observations in a row" do
      let!(:observation_1) do
        FactoryBot.create(
          :observation,
          date: DateTime.current - 3.days,
          user: user
        )
      end

      let!(:observation_2) do
        FactoryBot.create(
          :observation,
          date: DateTime.current - 2.days,
          user: user
        )
      end

      let!(:observation_3) do
        FactoryBot.create(
          :observation,
          date: DateTime.current - 1.day,
          user: user
        )
      end

      it "returns 3" do
        expect(helper.calculate_streak).to eq(3)
      end
    end

    describe "when the observation for today is added" do
      let!(:observation_1) do
        FactoryBot.create(
          :observation,
          date: DateTime.current - 3.days,
          user: user
        )
      end

      let!(:observation_2) do
        FactoryBot.create(
          :observation,
          date: DateTime.current - 2.days,
          user: user
        )
      end

      let!(:observation_3) do
        FactoryBot.create(
          :observation,
          date: DateTime.current - 1.day,
          user: user
        )
      end

      let!(:observation_4) do
        FactoryBot.create(
          :observation,
          date: DateTime.current,
          user: user
        )
      end

      it "adds 1 to the counter" do
        expect(helper.calculate_streak).to eq(4)
      end
    end

    describe "when the streak is broken" do
      let!(:observation_1) do
        FactoryBot.create(
          :observation,
          date: DateTime.current - 6.days,
          user: user
        )
      end

      let!(:observation_2) do
        FactoryBot.create(
          :observation,
          date: DateTime.current - 5.days,
          user: user
        )
      end

      let!(:observation_3) do
        FactoryBot.create(
          :observation,
          date: DateTime.current - 1.day,
          user: user
        )
      end

      it "does not count earlier observations" do
        expect(helper.calculate_streak).to eq(1)
      end
    end
  end
end
