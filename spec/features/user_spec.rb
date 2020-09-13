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
      expect(page).to have_content(
        "Welcome! You have signed up successfully"
      )
      expect(page).to have_current_path(dashboard_overview_path)
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

  context "When editing profile details" do
    before do
      login_as(user)
      visit edit_user_registration_path
    end

    let(:user) { FactoryBot.create(:user, time_zone: "Amsterdam") }

    it "correctly show the user details" do
      expect(page).to have_field("user_email", with: user.email)
      expect(page).to have_field("user_time_zone", with: "Amsterdam")
    end

    it "allows the user to update their profile" do
      select("Sarajevo", from: "user_time_zone")
      fill_in "user_current_password", with: user.password
      click_button "Update"
      expect(page).to have_content "Your account has been updated successfully"
      expect(user.reload.time_zone).to eq("Sarajevo")
    end
  end
end
