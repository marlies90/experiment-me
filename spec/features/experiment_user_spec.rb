# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExperimentUser, type: :feature do
  include ActiveJob::TestHelper

  let(:current_user) { FactoryBot.create(:user) }
  let(:experiment) { FactoryBot.create(:experiment) }
  let!(:experiment_user) do
    FactoryBot.create(:experiment_user, :active, experiment: experiment, user: current_user)
  end
  let(:enqueued_jobs) { ActiveJob::Base.queue_adapter.enqueued_jobs }

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

        before { click_link "Start this experiment" }

        it "allows the user to start a new experiment today" do
          select("Today", from: "experiment_user_starting_date")
          all(class: "experiment_user_experiment_user_measurements_starting_score").each do |score|
            score.choose(class: "radio_buttons", option: "4")
          end
          click_button "Start this experiment"
          find(".sidebar .experiments").click

          within ".current_experiment" do
            expect(page).to have_content experiment.name
          end

          expect(ExperimentUser.first.starting_date).to be_within(1.second)
            .of(DateTime.current)
          expect(ExperimentUser.first.ending_date).to be_within(1.second)
            .of((DateTime.current + 21).end_of_day)
        end

        it "allows the user to start a new experiment tomorrow" do
          select("Tomorrow", from: "experiment_user_starting_date")
          all(class: "experiment_user_experiment_user_measurements_starting_score").each do |score|
            score.choose(class: "radio_buttons", option: "4")
          end
          click_button "Start this experiment"
          find(".sidebar .experiments").click

          within ".current_experiment" do
            expect(page).to have_content experiment.name
          end

          expect(ExperimentUser.first.starting_date).to be_within(1.second)
            .of((DateTime.current + 1).beginning_of_day)
          expect(ExperimentUser.first.ending_date).to be_within(1.second)
            .of((DateTime.current + 22).end_of_day)
        end

        it "does not allow a user to start an experiment without filling in the starting survey" do
          select("Tomorrow", from: "experiment_user_starting_date")
          click_button "Start this experiment"
          expect(page).to have_content "Starting score can't be blank"
        end

        it "does not show the ending survey or cancellation reason" do
          expect(page).to_not have_content "Your ending measurement"
          expect(page).to_not have_content "You're cancelling the experiment"
        end

        it "sends the experiment start mail" do
          select("Today", from: "experiment_user_starting_date")
          all(class: "experiment_user_experiment_user_measurements_starting_score").each do |score|
            score.choose(class: "radio_buttons", option: "4")
          end
          click_button "Start this experiment"

          expect(enqueued_jobs.first["arguments"]).to include("experiment_start_email")
        end

        it "sends an event to Google Analytics" do
          event = spy(GoogleAnalyticsEvent)
          expect(GoogleAnalyticsEvent).to receive(:new)
            .with("Experiment user", "Creation", experiment.slug.to_s, "")
            .and_return(event)

          select("Today", from: "experiment_user_starting_date")
          all(class: "experiment_user_experiment_user_measurements_starting_score").each do |score|
            score.choose(class: "radio_buttons", option: "4")
          end
          click_button "Start this experiment"
        end
      end

      context "with an active experiment" do
        context "when visiting the current experiment show page" do
          it "tells the user this experiment is currently in progress" do
            expect(page).to have_content "You're currently doing this experiment"
            expect(page).to have_css(".start_experiment .disabled")
          end
        end

        context "when visiting an untried experiment show page" do
          let(:other_experiment) { FactoryBot.create(:experiment) }

          before do
            visit experiment_path(id: other_experiment.slug, category: other_experiment.category)
          end

          it "does not allow a user to start a new experiment" do
            expect(page).to have_content "You can run only one experiment at a time"
            expect(page).to have_css(".start_experiment .disabled")
          end
        end

        context "when visiting a completed experiment show page" do
          let(:completed_experiment) { FactoryBot.create(:experiment) }
          let!(:experiment_user) do
            FactoryBot.create(
              :experiment_user,
              :completed,
              experiment: completed_experiment,
              user: current_user
            )
          end

          before do
            visit experiment_path(
              id: completed_experiment.slug,
              category: completed_experiment.category
            )
          end

          it "tells the user the experiment has already been done" do
            expect(page).to have_content "You've already completed this experiment"
            expect(page).to have_css(".start_experiment .disabled")
          end
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
        end

        expect(ExperimentUser.first.starting_date).to be_within(1.second)
          .of((DateTime.current - 1).beginning_of_day)
        expect(ExperimentUser.first.ending_date).to be_within(1.second)
          .of((DateTime.current + 20).end_of_day)

        click_link("Cancel experiment")
        select("I accidentally started it", from: "experiment_user_cancellation_reason")
        click_button("Stop this experiment")

        within ".cancelled_experiments" do
          expect(page).to have_content experiment.name
        end

        expect(ExperimentUser.first.starting_date).to be_within(1.second)
          .of((DateTime.current - 1).beginning_of_day)
        expect(ExperimentUser.first.ending_date).to be_within(1.second)
          .of(DateTime.current)
      end

      it "does not show the starting or ending survey" do
        click_link "Cancel experiment"
        expect(page).to_not have_content "Your starting measurement"
        expect(page).to_not have_content "Your ending measurement"
      end

      it "sends an event to Google Analytics" do
        event = spy(GoogleAnalyticsEvent)
        expect(GoogleAnalyticsEvent).to receive(:new)
          .with("Experiment user", "Cancellation", experiment.slug.to_s, "")
          .and_return(event)

        click_link("Cancel experiment")
        select("I accidentally started it", from: "experiment_user_cancellation_reason")
        click_button("Stop this experiment")
      end
    end

    context "when an experiment has been cancelled" do
      let!(:experiment_user) do
        FactoryBot.create(
          :experiment_user,
          :cancelled,
          experiment: experiment,
          user: current_user
        )
      end

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
          end

          expect(ExperimentUser.first.starting_date).to be_within(1.second)
            .of(DateTime.current)
          expect(ExperimentUser.first.ending_date).to be_within(1.second)
            .of((DateTime.current + 21).end_of_day)
        end

        it "lets the user fill in the starting survey again" do
          click_link("Retry this experiment")
          expect(page).to have_content "Your starting measurement"
          click_button("Start this experiment")
        end

        it "does not show the ending survey or cancellation reason" do
          click_link "Retry this experiment"
          expect(page).to_not have_content "Your ending measurement"
          expect(page).to_not have_content "You're cancelling the experiment"
        end

        it "sends the experiment start mail" do
          click_link "Retry this experiment"
          select("Today", from: "experiment_user_starting_date")
          all(class: "experiment_user_experiment_user_measurements_starting_score").each do |score|
            score.choose(class: "radio_buttons", option: "4")
          end
          click_button "Start this experiment"

          expect(enqueued_jobs.first["arguments"]).to include("experiment_start_email")
        end

        it "sends an event to Google Analytics" do
          event = spy(GoogleAnalyticsEvent)
          expect(GoogleAnalyticsEvent).to receive(:new)
            .with("Experiment user", "Reactivation", experiment.slug.to_s, "")
            .and_return(event)

          click_link "Retry this experiment"
          select("Today", from: "experiment_user_starting_date")
          all(class: "experiment_user_experiment_user_measurements_starting_score").each do |score|
            score.choose(class: "radio_buttons", option: "4")
          end
          click_button "Start this experiment"
        end
      end

      context "when the user already has an active experiment" do
        let!(:active_experiment) { FactoryBot.create(:experiment) }
        let!(:active_experiment_user) do
          FactoryBot.create(
            :experiment_user,
            :active,
            experiment: active_experiment,
            user: current_user
          )
        end

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

    context "when an experiment has been running for 21 days" do
      let!(:experiment_user) do
        FactoryBot.create(
          :experiment_user,
          :completing,
          experiment: experiment,
          user: current_user,
          starting_date: (DateTime.current - 22).beginning_of_day,
          ending_date: (DateTime.current - 1).end_of_day
        )
      end

      it "lets the user complete it" do
        expect(page).to have_content "You completed your experiment"

        click_link("Finalize experiment")
        expect(page).to have_content "You're completing the experiment"
        all(class: "experiment_user_experiment_user_measurements_ending_score").each do |score|
          score.choose(class: "radio_buttons", option: "4")
        end
        select("Very easy", from: "experiment_user_difficulty")
        select("Moderate", from: "experiment_user_life_impact")

        click_button("Complete this experiment")

        within ".completed_experiments" do
          expect(page).to have_content experiment.name
        end
      end

      it "does not let the user complete it without the ending measurements" do
        expect(page).to have_content "You completed your experiment"

        click_link("Finalize experiment")
        expect(page).to have_content "You're completing the experiment"
        click_button("Complete this experiment")

        expect(page).to have_content "Ending score can't be blank"
        expect(page).to have_content "Difficulty can't be blank"
        expect(page).to have_content "Life impact can't be blank"
      end

      it "does not show the starting survey or cancellation reason" do
        click_link "Finalize experiment"
        expect(page).to_not have_content "Your starting measurement"
        expect(page).to_not have_content "You're cancelling the experiment"
      end

      it "sends an event to Google Analytics upon completion" do
        event = spy(GoogleAnalyticsEvent)
        expect(GoogleAnalyticsEvent).to receive(:new)
          .with("Experiment user", "Completion", experiment.slug.to_s, "")
          .and_return(event)

        click_link("Finalize experiment")
        expect(page).to have_content "You're completing the experiment"
        all(class: "experiment_user_experiment_user_measurements_ending_score").each do |score|
          score.choose(class: "radio_buttons", option: "4")
        end
        select("Very easy", from: "experiment_user_difficulty")
        select("Moderate", from: "experiment_user_life_impact")

        click_button("Complete this experiment")
      end
    end

    context "when an experiment has been completed" do
      let!(:experiment_user) do
        FactoryBot.create(
          :experiment_user,
          :completed,
          experiment: experiment,
          user: current_user
        )
      end

      it "lets the user view their starting and ending measurements" do
        click_link("View report")
        expect(page).to have_content(
          experiment_user.experiment_user_measurements.first.starting_score
        )
        expect(page).to have_content(
          experiment_user.experiment_user_measurements.first.ending_score
        )
        expect(page).to have_content(
          experiment_user.experiment_user_measurements.last.starting_score
        )
        expect(page).to have_content(
          experiment_user.experiment_user_measurements.last.ending_score
        )
      end

      it "lets the user view how they rated the difficulty and life impact options" do
        click_link("View report")
        expect(page).to have_content(
          ExperimentUser::DIFFICULTY_RATES[experiment_user.difficulty]
        )

        expect(page).to have_content(
          ExperimentUser::LIFE_IMPACT_OPTIONS[experiment_user.life_impact]
        )
      end

      it "lets the user see their note" do
        click_link("View report")
        expect(page).to have_content(experiment_user.ending_note)
      end

      it "lets the user see their recommendation" do
        click_link("View report")
        expect(page).to have_content(experiment_user.recommendation)
      end
    end
  end
end
