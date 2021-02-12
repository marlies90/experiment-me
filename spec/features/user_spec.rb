# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :feature do
  context "When signing up" do
    before do
      visit new_user_registration_path
    end

    context "new profile" do
      it "allows for succesful creation of a new user profile" do
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
        expect(page).to have_current_path(dashboard_lab_path)
        expect(User.count).to be 1
      end

      it "does not allow bots to sign up" do
        within ".form" do
          fill_in "user_first_name", with: Faker::Name.first_name
          fill_in "user_email", with: Faker::Internet.email
          fill_in "user_password", with: "000000"
          fill_in "user_password_confirmation", with: "000000"
          select("(GMT+01:00) Amsterdam", from: "user_time_zone")
          fill_in "user_age", with: "50"
          page.check("user_terms_agreement")
        end
        click_button "Sign up"

        expect(User.count).to be 0
      end

      it "sends an event to Google Analytics" do
        event = spy(GoogleAnalyticsEvent)
        expect(GoogleAnalyticsEvent).to receive(:new)
          .with("User", "Registration", "", "")
          .and_return(event)

        within ".form" do
          fill_in "user_first_name", with: Faker::Name.first_name
          fill_in "user_email", with: Faker::Internet.email
          fill_in "user_password", with: "000000"
          fill_in "user_password_confirmation", with: "000000"
          select("(GMT+01:00) Amsterdam", from: "user_time_zone")
          page.check("user_terms_agreement")
        end
        click_button "Sign up"
      end
    end

    context "profile already exists for this email" do
      let!(:existing_user) { FactoryBot.create(:user, email: "already_used@gmail.com") }

      it "does not allow that email to be used again" do
        expect(User.count).to be 1

        within ".form" do
          fill_in "user_first_name", with: Faker::Name.first_name
          fill_in "user_email", with: "already_used@gmail.com"
          fill_in "user_password", with: "000000"
          fill_in "user_password_confirmation", with: "000000"
          select("(GMT+01:00) Amsterdam", from: "user_time_zone")
          page.check("user_terms_agreement")
        end
        click_button "Sign up"
        expect(page).to have_content(
          "Email has already been taken"
        )

        expect(User.count).to be 1
      end
    end
  end

  context "When signing in" do
    let(:existing_user) { FactoryBot.create(:user) }

    it "Allows an existing user to sign in" do
      visit new_user_session_path
      fill_in "user_email", with: existing_user.email
      fill_in "user_password", with: existing_user.password
      click_button "Log in"
      expect(page).to have_content "Signed in successfully"
    end

    it "Allows the user to request a password reset" do
      visit new_user_session_path
      click_link "Forgot your password?"
      fill_in "user_email", with: existing_user.email
      click_button "Reset my password"
      expect(page).to have_content "You will receive an email with instructions"
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

    it "allows the user to update their account" do
      within ".account_settings" do
        select("Sarajevo", from: "user_time_zone")
        fill_in "user_current_password", with: user.password
        click_button "Update account"
      end
      expect(page).to have_content "Your account has been updated successfully"
      expect(user.reload.time_zone).to eq("Sarajevo")
    end

    it "allows the user to update their password" do
      within ".password_settings" do
        fill_in "user_current_password", with: user.password
        fill_in "user_password", with: "1234567"
        fill_in "user_password_confirmation", with: "1234567"
        click_button "Update password"
      end
      expect(page).to have_content "Your account has been updated successfully"
      expect(user.reload.valid_password?("1234567")).to be(true)
    end

    it "allows the user to delete their profile" do
      click_button "Delete my account"

      expect(page).to have_content "Your account has been deleted successfully"
      expect { user.reload }.to raise_exception(ActiveRecord::RecordNotFound)
    end
  end
end
