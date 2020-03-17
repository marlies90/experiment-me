# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExperimentUserPolicy do
  subject { ExperimentUserPolicy.new(user, experiment) }
  let(:experiment) { FactoryBot.create(:experiment) }

  context "When not logged in" do
    let(:user) { nil }

    it { should forbid_actions(%i[create new update]) }
  end

  context "When logged in as a standard user" do
    let(:user) { FactoryBot.create(:user) }

    it { should permit_actions(%i[create new update]) }
  end

  context "When logged in as an admin user" do
    let(:user) { FactoryBot.create(:user, :admin) }

    it { should permit_actions(%i[create new update]) }
  end
end
