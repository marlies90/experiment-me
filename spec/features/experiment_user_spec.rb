require 'rails_helper'

RSpec.describe ExperimentUser, type: :feature do
  let(:current_user) { FactoryBot.create(:user) }
  let(:experiment) { FactoryBot.create(:experiment) }
  let!(:experiment_user) { FactoryBot.create(:experiment_user, :active, experiment: experiment, user: current_user) }

  before do
    login_as(current_user)
  end

  context "When on the experiment show page" do
    before do
      visit experiment_path(id: experiment.slug, category: experiment.category)
    end

    context "when not logged in" do
      let(:current_user) { nil }
      let!(:experiment_user) { nil }

      it "redirects to the sign in page" do
        click_link "Start this experiment"
        expect(page).to have_content "Log in"
        expect(page).to have_content "Sign up"
      end
    end

    context "when logged in" do
      context "without any other active experiment" do
        let!(:experiment_user) { nil }

        it "allows a user to succesfully start a new experiment" do
          click_link "Start this experiment"
          click_button "Start this experiment"
          expect(page).to have_content "You have successfully started the experiment"
          expect(page).to have_content "You're doing the experiment \"#{experiment.name}\""
        end
      end

      context "with another active experiment" do
        it "does not allow a user to start a new experiment" do
          expect(page).to have_content "You can run only one experiment at a time"
          expect(page).to have_css(".start_experiment .disabled")
        end
      end
    end
  end

  context "When on the experiment dashboard page" do
    before do
      visit dashboard_experiments_path
    end

    context "when no experiments are active or cancelled" do
      let!(:experiment_user) { nil }

      it "shows a link that lets the user start a new experiment" do
        within ".current_experiment" do
          expect(page).to have_link "Choose experiment"
        end
      end
    end

    context "when an experiment is active" do
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

    context "when an experiment has been cancelled" do
      let!(:experiment_user) { FactoryBot.create(:experiment_user, :cancelled, experiment: experiment, user: current_user) }

      before do
        visit dashboard_experiments_path
      end

      context "when the user doesn't already have an active experiment" do
        it "allows the user to reactivate that experiment" do
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

      context "when the user already has an active experiment" do
        let!(:active_experiment) { FactoryBot.create(:experiment) }
        let!(:active_experiment_user) { FactoryBot.create(:experiment_user, :active, experiment: active_experiment, user: current_user) }

        before do
          visit dashboard_experiments_path
        end

        it "does not allow the user to reactivate an experiment" do
          within ".current_experiment" do
            expect(page).to have_content active_experiment.name
          end
          expect(page).to have_content "You can run only one experiment at a time"
          expect(page).to have_css(".cancelled_experiments .disabled")
        end
      end
    end
  end
end
