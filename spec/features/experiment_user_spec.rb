require 'rails_helper'

RSpec.describe ExperimentUser, type: :feature do
  let(:user) { FactoryBot.create(:user) }
  let(:experiment) { FactoryBot.create(:experiment) }

  before do
    login_as(user)
  end

  context "When starting a new experiment" do
    before do
      visit experiment_path(id: experiment.slug, category: experiment.category)
    end

    it "Allows a user to succesfully start a new experiment" do
      click_link "Start this experiment"
      click_button "Start this experiment"
      expect(page).to have_content "You have successfully started the experiment"
      expect(page).to have_content "You're doing the experiment \"#{experiment.name}\""
    end
  end

  # context "When an experiment has been created" do
  #   let!(:experiment) { FactoryBot.create(:experiment, category: category) }
  #
  #   before do
  #     visit dashboard_admin_path
  #   end
  #
  #   it "Allows the user to cancel that experiment" do
  #     within ".experiments" do
  #       click_link "Show"
  #     end
  #
  #     expect(page).to have_content "Start this experiment"
  #   end
  # end
end
