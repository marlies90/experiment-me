# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :feature do
  context "When signing up" do
    it "Allows for succesful creation of a new user profile" do
      visit new_user_registration_path
      within ".form" do
        fill_in "user_first_name", with: Faker::Name.first_name
        fill_in "user_email", with: Faker::Internet.email
        fill_in "user_password", with: "000000"
        fill_in "user_password_confirmation", with: "000000"
        select("(GMT+01:00) Amsterdam", from: "user_time_zone")
        page.check("user_terms_agreement")
      end
      click_button "Sign up"
      expect(page).to have_content "You have signed up successfully"
    end
  end

  context "When signing in" do
    let!(:existing_user) { FactoryBot.create(:user) }

    it "Allows an existing user to sign in" do
      visit new_user_session_path
      fill_in "user_email", with: existing_user.email
      fill_in "user_password", with: existing_user.password
      click_button "Log in"
      expect(page).to have_content "Signed in successfully"
    end
  end
end
