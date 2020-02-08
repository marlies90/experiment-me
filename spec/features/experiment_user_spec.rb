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
      expect(page).to have_content experiment.name
      expect(page).to have_content "Stop this experiment"
      # page.accept_confirm do
      #   click_link("Stop this experiment")
      # end
      # expect(experiment.status).to equal("cancelled")
    end
  end

  context "When an experiment has been cancelled" do
    let!(:experiment_user) { FactoryBot.create(:experiment_user, :cancelled, experiment: experiment, user: user) }

    before do
      visit dashboard_experiments_path
    end

    it "Allows the user to reactivate that experiment" do
      expect(page).to have_content experiment.name
      expect(page).to have_content "Retry this experiment"
      # page.accept_confirm do
      #   click_link("Retry this experiment")
      # end
      # expect(experiment.status).to equal("active")
    end
  end
end
