# frozen_string_literal: true

require "rails_helper"

RSpec.describe Image, type: :feature do
  let(:admin) { FactoryBot.create(:user, :admin) }

  before do
    login_as(admin)
  end

  context "When creating a new image" do
    before do
      visit new_image_path
    end

    it "Allows a valid image to be created succesfully" do
      fill_in "image_name", with: Faker::Superhero.name
      fill_in "image_alt", with: Faker::Lorem.paragraph
      # fill_in "Image", with: Faker::Avatar.image

      click_button "Save image"
      expect(page).to have_content "Image was successfully created."
    end
  end

  context "When an image has been created" do
    let!(:image) { FactoryBot.create(:image) }

    before do
      visit dashboard_admin_path
    end

    it "Allows the user to go into editing mode" do
      within ".admin-panel .images" do
        click_link "Edit"
      end

      expect(page).to have_content "Editing Image"
    end

    it "Allows the user to update that image" do
      within ".admin-panel .images" do
        click_link "Edit"
      end

      # fill_in "Image", with: Faker::Avatar.image
      click_button("Save image")
      expect(page).to have_content "Image was successfully updated."
    end

    it "Allows the user to delete that image" do
      within ".admin-panel .images" do
        click_link "Destroy"
      end

      expect(page).to have_content "Image was successfully destroyed."
    end
  end
end
