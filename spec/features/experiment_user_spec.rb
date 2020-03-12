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

        it "allows the user to start a new experiment today" do
          click_link "Start this experiment"
          select("Today", from: "experiment_user_starting_date")
          all(class: "experiment_user_experiment_user_measurements_starting_score").each do |measurement|
            measurement.choose(class: "radio_buttons", option: "8")
          end
          click_button "Start this experiment"
          find(".sidebar .experiments a").click

          within ".current_experiment" do
            expect(page).to have_content experiment.name
            expect(find(".starting_date").text.to_datetime).to be_within(1.second).of((DateTime.current))
            expect(find(".ending_date").text.to_datetime).to be_within(1.second).of((DateTime.current + 21).end_of_day)
          end
        end

        it "allows the user to start a new experiment tomorrow" do
          click_link "Start this experiment"
          select("Tomorrow", from: "experiment_user_starting_date")
          all(class: "experiment_user_experiment_user_measurements_starting_score").each do |measurement|
            measurement.choose(class: "radio_buttons", option: "8")
          end
          click_button "Start this experiment"
          find(".sidebar .experiments a").click

          within ".current_experiment" do
            expect(page).to have_content experiment.name
            expect(find(".starting_date").text.to_datetime).to be_within(1.second).of((DateTime.current + 1).beginning_of_day)
            expect(find(".ending_date").text.to_datetime).to be_within(1.second).of((DateTime.current + 22).end_of_day)
          end
        end

        it "does not allow the user to start a new experiment without filling in the starting survey" do
          click_link "Start this experiment"
          select("Tomorrow", from: "experiment_user_starting_date")
          click_button "Start this experiment"
          expect(page).to have_content "Starting score can't be blank"
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
      it "allows the user to stop that experiment" do
        within ".current_experiment" do
          expect(page).to have_content experiment.name
          expect(find(".starting_date").text.to_datetime).to be_within(1.second).of((DateTime.current - 1).beginning_of_day)
          expect(find(".ending_date").text.to_datetime).to be_within(1.second).of((DateTime.current + 20).end_of_day)
        end

        click_link("Stop this experiment")
        select("I have no time to focus on it right now", from: "experiment_user_cancellation_reason")
        click_button("Stop this experiment")

        within ".cancelled_experiments" do
          expect(page).to have_content experiment.name
          expect(find(".starting_date").text.to_datetime).to be_within(1.second).of((DateTime.current - 1).beginning_of_day)
          expect(find(".ending_date").text.to_datetime).to be_within(1.second).of(DateTime.current)
          expect(find(".cancellation_reason")).to have_content "I have no time to focus on it right now"
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
          expect(page).to have_content "Start"
          click_button("Start this experiment")

          within ".current_experiment" do
            expect(page).to have_content experiment.name
            expect(find(".starting_date").text.to_datetime).to be_within(1.second).of((DateTime.current).beginning_of_day)
            expect(find(".ending_date").text.to_datetime).to be_within(1.second).of((DateTime.current + 21).end_of_day)
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

      context "when an experiment has been running for 21 days" do
        let!(:experiment_user) { FactoryBot.create(
          :experiment_user,
          :active,
          experiment: experiment,
          user: current_user,
          starting_date: (DateTime.current - 22).beginning_of_day,
          ending_date: (DateTime.current - 1).end_of_day
          ) }

        it "lets the user complete it" do
          expect(page).to have_content "YAY! You completed your experiment"

          click_link("Evaluate experiment")
          expect(page).to have_content "Evaluate"
          click_button("Evaluate this experiment")

          within ".completed_experiments" do
            expect(page).to have_content experiment.name
          end
        end
      end
    end
  end
end
