# frozen_string_literal: true

require "rails_helper"

RSpec.describe Category, type: :feature do
  let(:admin) { FactoryBot.create(:user, :admin) }
  let!(:category) { FactoryBot.create(:category) }
  let!(:benefit) { FactoryBot.create(:benefit) }

  before do
    login_as(admin)
  end

  context "When creating a new category" do
    before do
      visit new_category_path
    end

    it "Allows a valid category to be created succesfully" do
      fill_in "category_name", with: Faker::Superhero.name
      fill_in "category_description", with: Faker::Lorem.paragraph
      # fill_in "Image", with: Faker::Avatar.image

      click_button "Save category"
      expect(page).to have_content "Category was successfully created."
    end
  end

  context "When an category has been created" do
    let!(:category) { FactoryBot.create(:category) }

    before do
      visit dashboard_admin_path
    end

    it "Allows the user to view that category" do
      within ".admin-panel .categories" do
        click_link "Show"
      end

      expect(page).to have_content category.description.to_s
    end

    it "Allows the user to go into editing mode" do
      within ".admin-panel .categories" do
        click_link "Edit"
      end

      expect(page).to have_content "Editing Category"
    end

    it "Allows the user to update that category" do
      within ".admin-panel .categories" do
        click_link "Edit"
      end

      # fill_in "Image", with: Faker::Avatar.image
      click_button("Save category")
      expect(page).to have_content "Category was successfully updated."
    end

    it "Allows the user to delete that category" do
      within ".admin-panel .categories" do
        click_link "Destroy"
      end

      expect(page).to have_content "Category was successfully destroyed."
    end
  end
end
