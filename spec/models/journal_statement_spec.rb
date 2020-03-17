# frozen_string_literal: true

require "rails_helper"

RSpec.describe JournalStatement, type: :model do
  subject { build(:journal_statement) }

  describe "associations" do
    it { is_expected.to respond_to(:journal_ratings) }
    it { is_expected.to validate_presence_of(:name) }
  end

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  it "is not valid without a name" do
    subject.name = nil
    expect(subject).to_not be_valid
  end
end
