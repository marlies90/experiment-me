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

  context "When an experiment has been started" do
    let!(:experiment_user) { FactoryBot.create(:experiment_user, :active, experiment: experiment, user: user) }

    before do
      visit dashboard_experiments_path
    end

    it "Allows the user to stop that experiment" do
      within ".current_experiment" do
        expect(page).to have_content experiment.name
      end

      click_link("Stop this experiment")
      click_button("Stop this experiment")

      within ".cancelled_experiments" do
        expect(page).to have_content experiment.name
      end
    end
  end

  context "When an experiment has been cancelled" do
    let!(:experiment_user) { FactoryBot.create(:experiment_user, :cancelled, experiment: experiment, user: user) }

    before do
      visit dashboard_experiments_path
    end

    it "Allows the user to reactivate that experiment" do
      within ".cancelled_experiments" do
        expect(page).to have_content experiment.name
      end

      click_link("Retry this experiment")
      click_button("Start this experiment")

      within ".current_experiment" do
        expect(page).to have_content experiment.name
      end
    end
  end
end
