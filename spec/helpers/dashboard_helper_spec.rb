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

  describe "#journal_entry_for_date" do
    describe "when a journal_entry exists for a user" do
      before { allow(helper).to receive(:current_user).and_return(user_one) }

      let(:user_one) { FactoryBot.create(:user) }
      let(:today) { DateTime.current.beginning_of_day }
      let!(:journal_entry_user_one) do
        FactoryBot.create(:journal_entry, user: user_one, date: today)
      end

      it "returns the correct journal_entry for the date given" do
        expect(helper.journal_entry_for_date(today)).to eq(journal_entry_user_one)
      end
    end

    describe "when a journal entry exists for a different user" do
      before { allow(helper).to receive(:current_user).and_return(user_one) }

      let(:user_one) { FactoryBot.create(:user) }
      let(:user_two) { FactoryBot.create(:user) }
      let(:today) { DateTime.current.beginning_of_day }
      let!(:journal_entry_user_two) do
        FactoryBot.create(:journal_entry, user: user_two, date: today)
      end

      it "does not return that journal_entry" do
        expect(helper.journal_entry_for_date(today)).to be_nil
      end
    end
  end
end
