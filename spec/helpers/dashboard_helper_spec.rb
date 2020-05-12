# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationHelper, type: :helper do
  describe "#active_experiment_day_counter" do
    let(:experiment_user) do
      FactoryBot.create(:experiment_user, :active, starting_date: 3.days.ago)
    end

    it "returns amount of days since start of the experiment and today" do
      expect(helper.active_experiment_day_counter(experiment_user)).to eq(3)
    end
  end
end
