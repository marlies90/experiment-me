# frozen_string_literal: true

require "rails_helper"

RSpec.describe JournalStatementsControllerPolicy do
  subject { JournalStatementsControllerPolicy.new(user, journal_statement) }
  let(:journal_statement) { FactoryBot.create(:journal_statement) }

  context "When not logged in" do
    let(:user) { nil }

    it { should forbid_actions(%i[create new update edit destroy]) }
  end

  context "When logged in as a standard user" do
    let(:user) { FactoryBot.create(:user) }

    it { should forbid_actions(%i[create new update edit destroy]) }
  end

  context "When logged in as an admin user" do
    let(:user) { FactoryBot.create(:user, :admin) }

    it { should permit_actions(%i[create new update edit destroy]) }
  end
end
