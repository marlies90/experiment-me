# frozen_string_literal: true

require "rails_helper"

RSpec.describe JournalEntriesControllerPolicy do
  subject { JournalEntriesControllerPolicy.new(user, self) }
  let(:journal_entry) { FactoryBot.create(:journal_entry) }

  context "When not logged in" do
    let(:user) { nil }

    it { should forbid_actions(%i[show index create new update edit destroy]) }
  end

  context "When logged in as a standard user" do
    let(:user) { FactoryBot.create(:user) }

    context "grants the user access to their journal entries" do
      it { should permit_actions(%i[show index create new update edit destroy]) }
    end
  end
end
