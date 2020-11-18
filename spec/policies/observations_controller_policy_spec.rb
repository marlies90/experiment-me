# frozen_string_literal: true

require "rails_helper"

RSpec.describe ObservationsControllerPolicy do
  subject { ObservationsControllerPolicy.new(user, self) }
  let(:observation) { FactoryBot.create(:observation) }

  context "When not logged in" do
    let(:user) { nil }

    it { should forbid_actions(%i[show index create new update edit destroy]) }
  end

  context "When logged in as a standard user" do
    let(:user) { FactoryBot.create(:user) }

    context "grants the user access to their observations" do
      it { should permit_actions(%i[show index create new update edit destroy]) }
    end
  end
end
