require 'rails_helper'

RSpec.describe JournalEntriesControllerPolicy do
  subject { JournalEntriesControllerPolicy.new(user, self) }
  let(:journal_entry) { FactoryBot.create(:journal_entry) }

  context "When not logged in" do
    let(:user) { nil }

    it { should forbid_actions(%i[show index create new update edit destroy]) }
  end

  context "When logged in as a standard user" do
    let(:user) { FactoryBot.create(:user) }

    context "shows the journal_entries of that user" do
      it { should permit_actions(%i[show index create new update edit destroy]) }
    end
  end

  context "When logged in as a standard user" do
    # it "does not show the journal_entries of a different user" do
    #   let(:user) { FactoryBot.create(:user, :admin) }
    #
    #   it { should permit_actions(%i[show index create new update edit destroy]) }
    # end
  end
end
