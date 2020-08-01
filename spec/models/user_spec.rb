# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  subject { build(:user) }

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  it "is not valid without a first name" do
    subject.first_name = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a first name that is too long" do
    subject.first_name = "Thisissuchalongnameitisdefinitelymorethanfourtycharacters"
    expect(subject).to_not be_valid
  end

  it "is not valid without an email" do
    subject.email = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a password" do
    subject.password = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a time zone" do
    subject.time_zone = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without having accepted the terms and conditions" do
    subject.terms_agreement = false
    expect(subject).to_not be_valid
  end
end
