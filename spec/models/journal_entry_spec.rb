require 'rails_helper'

RSpec.describe JournalEntry, type: :model do
  subject { build(:journal_entry_with_ratings) }

  describe "associations" do
    it { is_expected.to respond_to(:user) }
    it { is_expected.to respond_to(:journal_ratings) }
    it { is_expected.to validate_presence_of(:journal_ratings) }
    it { is_expected.to validate_presence_of(:user_id) }
    it { is_expected.to validate_presence_of(:date) }
  end

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  it "is not valid without a date" do
    subject.date = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a user_id" do
    subject.user_id = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without scores for all journal_statements" do
    subject.journal_ratings = []
    expect(subject).to_not be_valid
  end
end
