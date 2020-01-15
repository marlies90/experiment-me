require 'rails_helper'

RSpec.describe JournalRating, type: :model do
  let(:journal_entry) { FactoryBot.build_stubbed(:journal_entry) }
  subject { build(:journal_rating, journal_entry: journal_entry) }

  describe "associations" do
    it { is_expected.to respond_to(:journal_entry) }
    it { is_expected.to respond_to(:journal_statement) }
    it { is_expected.to validate_presence_of(:journal_entry) }
    it { is_expected.to validate_presence_of(:journal_statement) }
    it { is_expected.to validate_presence_of(:score) }
  end

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  it "is not valid without a name" do
    subject.score = nil
    expect(subject).to_not be_valid
  end
end
