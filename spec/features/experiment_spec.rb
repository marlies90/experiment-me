require 'rails_helper'

RSpec.describe Experiment, type: :feature do
  let(:admin) { FactoryBot.create(:user, :admin) }
  let!(:category) { FactoryBot.create(:category) }

  before do
    login_as(admin)
  end

  context "When creating a new experiment" do
    before do
      visit new_experiment_path
    end

    it "Allows a valid experiment to be created succesfully" do
      fill_in "experiment_name", with: Faker::Superhero.name
      fill_in "Description", with: Faker::Lorem.paragraph
      # fill_in "Image", with: Faker::Avatar.image
      fill_in "Objective", with: Faker::Lorem.sentence
      fill_in class: "benefit_name", match: :first, with: Faker::Games::Zelda.item

      click_button "Save experiment"
      expect(page).to have_content "Experiment was successfully created."
    end
  end

  context "When an experiment has been created" do
    let!(:experiment) { FactoryBot.create(:experiment, category: category) }

    before do
      visit dashboard_admin_path
    end

    it "Allows the user to view that experiment" do
      within ".admin-panel .experiments" do
        click_link "Show"
      end

      expect(page).to have_content "Start this experiment"
    end

    it "Allows the user to go into editing mode" do
      within ".admin-panel .experiments" do
        click_link "Edit"
      end

      expect(page).to have_content "Editing Experiment"
    end

    it "Allows the user to update that experiment" do
      within ".admin-panel .experiments" do
        click_link "Edit"
      end

      # fill_in "Image", with: Faker::Avatar.image
      click_button("Save experiment")
      expect(page).to have_content "Experiment was successfully updated."
    end

    it "Allows the user to delete that experiment" do
      within ".admin-panel .experiments" do
        click_link "Destroy"
      end

      expect(page).to have_content "Experiment was successfully destroyed."
    end
  end
end
