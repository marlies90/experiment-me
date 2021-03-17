# frozen_string_literal: true

require "rails_helper"

RSpec.describe MailPreference, type: :model do
  subject { build(:mail_preference, :experiment_start) }

  describe "associations" do
    it { is_expected.to respond_to(:user) }
    it { is_expected.to validate_presence_of(:mail_type) }
    it { is_expected.to validate_presence_of(:status) }
  end

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  it "is not valid without a mail_type" do
    subject.mail_type = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a status" do
    subject.status = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a user" do
    subject.user_id = nil
    expect(subject).to_not be_valid
  end
end
