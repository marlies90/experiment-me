# frozen_string_literal: true

require "rails_helper"

RSpec.describe Contact, type: :feature do
  context "When sending a message via the contact form" do
    before { visit new_contact_path }

    it "Allows for succesful sending of message" do
      within ".form" do
        fill_in "contact_name", with: Faker::Name.first_name
        fill_in "contact_email", with: Faker::Internet.email
        fill_in "contact_message", with: Faker::Name.first_name
      end
      click_button "Send Message"
      expect(page).to have_content(
        "Thank you for your message! It has been sent successfully."
      )
      expect(page).to have_current_path(contacts_thank_you_path)
    end

    it "does not allow empty fields" do
      click_button "Send Message"
      expect(page).to have_content("Name can't be blank")
      expect(page).to have_content("Email can't be blank")
      expect(page).to have_content("Message can't be blank")
    end
  end
end
