# frozen_string_literal: true

require "rails_helper"

RSpec.describe "UserTimeZoneSupport", type: :feature do
  include ActiveSupport::Testing::TimeHelpers

  before do
    travel_to DateTime.parse("17th Jun 2020 07:00:00 AM")
  end

  after do
    travel_back
  end

  context "When logged in as a user from Alaska" do
    # Alaska is GMT-9(summer)/GMT-8(winter)
    let(:alaskan_user) { FactoryBot.create(:user, time_zone: "Alaska") }

    before { login_as(alaskan_user) }

    context "When on the observation index page" do
      before do
        visit observations_path
      end

      context "when selecting a date for the new observation" do
        it "correctly autoselects today" do
          expect(page).to have_select("date", selected: "16 Jun 2020 (Tue)")
        end
      end

      context "when viewing the created observations in the last 14 days" do
        it "doesn't yet list the 17th as that is tomorrow to the Alaskan user" do
          within(".past_observations") do
            expect(page).to_not have_content("17 Jun (Wed)")
          end
        end
      end
    end

    context "When on the observation create page" do
      before do
        visit observations_path
        click_button("New observation")
      end

      it "displays the correct date in the header" do
        within ".jumbotron" do
          expect(page).to have_content("16 Jun")
        end
      end

      it "shows the correct date of this observation on the index page after saving" do
        choose("observation_mood_3")
        choose("observation_sleep_3")
        choose("observation_health_3")
        choose("observation_relax_3")
        choose("observation_connect_3")
        choose("observation_meaning_3")

        click_button "Save observation"
        visit observations_path

        within ".date-2020-06-16" do
          expect(page).to have_css(".fa-check")
        end
      end
    end

    context "When on the dashboard page" do
      context "when no observation exists for today" do
        it "has a call to action to fill it in" do
          visit observations_path
          select("15 Jun 2020 (Mon)", from: "date")
          click_button("New observation")

          choose("observation_mood_3")
          choose("observation_sleep_3")
          choose("observation_health_3")
          choose("observation_relax_3")
          choose("observation_connect_3")
          choose("observation_meaning_3")

          click_button "Save observation"

          visit dashboard_lab_path
          expect(page).to have_content("I want to keep track of how I'm feeling")
        end
      end

      context "when the observation exists for today" do
        it "shows the user it has been filled in" do
          visit observations_path
          click_button("New observation")

          choose("observation_mood_3")
          choose("observation_sleep_3")
          choose("observation_health_3")
          choose("observation_relax_3")
          choose("observation_connect_3")
          choose("observation_meaning_3")

          click_button "Save observation"

          visit dashboard_lab_path
          expect(page).to have_content("You've added your observation for today.")
        end
      end
    end

    context "When starting an experiment" do
      let(:category) { FactoryBot.create(:category) }
      let(:experiment) { FactoryBot.create(:experiment, category: category) }

      context "when starting today" do
        before do
          visit experiment_path(id: experiment.slug, category: category)
          click_link "Start this experiment"
          select("Today", from: "experiment_user_starting_date")
          all(class: "experiment_user_experiment_user_measurements_starting_score").each do |score|
            score.choose(class: "radio_buttons", option: "4")
          end
          click_button "Start this experiment"
        end

        it "shows the correct starting/ending dates on the experiment show page" do
          visit dashboard_experiments_path

          within ".current_experiment" do
            expect(page).to have_content experiment.name
            expect(find(".starting_date").text).to have_content("16 Jun")
            expect(find(".ending_date").text).to have_content("7 Jul")
          end
        end

        it "shows the correct starting/ending dates on the lab page" do
          visit dashboard_lab_path

          within ".phases" do
            expect(page).to have_content "From 16 Jun (Tue) to 7 Jul (Tue)"
          end
        end

        it "shows the experiment when creating a observation" do
          visit observations_path
          click_button("New observation")

          expect(page).to have_content experiment.name
        end

        context "#active_experiment_day_counter" do
          xit "correctly shows the user is on day 1 of the experiment" do
            visit dashboard_lab_path
            expect(page).to have_content "You're on day 1"
          end

          context "when the next day starts in local time" do
            before do
              travel_to DateTime.parse("17th Jun 2020 08:00:00 AM")
            end

            after do
              travel_back
            end

            xit "increases the counter at the correct local time" do
              visit dashboard_lab_path
              expect(page).to have_content "You're on day 2"
            end
          end
        end
      end

      context "when starting tomorrow" do
        before do
          visit experiment_path(id: experiment.slug, category: category)
          click_link "Start this experiment"
          select("Tomorrow", from: "experiment_user_starting_date")
          all(class: "experiment_user_experiment_user_measurements_starting_score").each do |score|
            score.choose(class: "radio_buttons", option: "4")
          end
          click_button "Start this experiment"
        end

        it "shows the correct starting/ending dates on the experiment show page" do
          visit dashboard_experiments_path

          within ".current_experiment" do
            expect(page).to have_content experiment.name
            expect(find(".starting_date").text).to have_content("17 Jun")
            expect(find(".ending_date").text).to have_content("8 Jul")
          end
        end

        it "shows the correct starting/ending dates on the lab page" do
          visit dashboard_lab_path

          within ".phases" do
            expect(page).to have_content "From 17 Jun (Wed) to 8 Jul (Wed)"
          end
        end

        it "does not yet show the experiment when creating a observation" do
          visit observations_path
          click_button("New observation")

          expect(page).to_not have_content experiment.name
        end

        context "#active_experiment_on_date(date)" do
          context "just before the next day starts in local time" do
            before do
              travel_to DateTime.parse("17th Jun 2020 06:00:00 AM")
            end

            after do
              travel_back
            end

            it "does not show the experiment when creating a new observation" do
              visit observations_path
              click_button("New observation")

              expect(page).to_not have_content experiment.name
            end
          end

          context "when the next day starts in local time" do
            before do
              travel_to DateTime.parse("17th Jun 2020 08:00:00 AM")
            end

            after do
              travel_back
            end

            it "does show the experiment when creating a new observation" do
              visit observations_path
              click_button("New observation")

              expect(page).to have_content experiment.name
            end
          end
        end

        context "#active_experiment_day_counter" do
          xit "correctly shows the user is on day 1 of the experiment" do
            visit dashboard_lab_path
            expect(page).to have_content "You're on day 0"
          end

          context "when the next day starts in local time" do
            before do
              travel_to DateTime.parse("17th Jun 2020 08:00:00 AM")
            end

            after do
              travel_back
            end

            xit "increases the counter at the correct local time" do
              visit dashboard_lab_path
              expect(page).to have_content "You're on day 1"
            end
          end
        end
      end
    end

    context "When canceling an experiment" do
      let(:category) { FactoryBot.create(:category) }
      let(:experiment) { FactoryBot.create(:experiment, category: category) }

      before do
        visit experiment_path(id: experiment.slug, category: category)
        click_link "Start this experiment"
        select("Today", from: "experiment_user_starting_date")
        all(class: "experiment_user_experiment_user_measurements_starting_score").each do |score|
          score.choose(class: "radio_buttons", option: "4")
        end
        click_button "Start this experiment"
        travel_to DateTime.parse("24th Jun 2020 07:00:00 AM")
      end

      after do
        travel_back
      end

      it "shows the correct starting/ending dates on the experiment show page" do
        visit dashboard_experiments_path
        click_link "Cancel experiment"
        click_button "Stop this experiment"

        within ".cancelled_experiments" do
          expect(find(".starting_date").text).to have_content("16 Jun 2020")
          expect(find(".ending_date").text).to have_content("23 Jun 2020")
        end
      end
    end

    context "When completing an experiment" do
      let(:category) { FactoryBot.create(:category) }
      let(:experiment) { FactoryBot.create(:experiment, category: category) }

      before do
        visit experiment_path(id: experiment.slug, category: category)
        click_link "Start this experiment"
        select("Today", from: "experiment_user_starting_date")
        all(class: "experiment_user_experiment_user_measurements_starting_score").each do |score|
          score.choose(class: "radio_buttons", option: "4")
        end
        click_button "Start this experiment"
        travel_to DateTime.parse("8 Jul 2020 08:00:00 AM")
        visit dashboard_experiments_path
      end

      after do
        travel_back
      end

      context "after 21 days" do
        it "shows the call to action to complete the experiment" do
          expect(page).to have_content("You completed your experiment")
        end

        it "shows the correct starting/ending dates for observations" do
          click_link "Finalize experiment"

          within ".during_dates" do
            expect(page).to have_content("16 Jun")
            expect(page).to have_content("7 Jul")
          end

          within ".before_dates" do
            expect(page).to have_content("15 Jun")
          end
        end

        it "shows the correct starting/ending dates on the experiment show page upon completion" do
          click_link "Finalize experiment"
          all(class: "experiment_user_experiment_user_measurements_ending_score").each do |score|
            score.choose(class: "radio_buttons", option: "4")
          end
          select("Very easy", from: "experiment_user_difficulty")
          select("Moderate", from: "experiment_user_life_impact")
          click_button("Complete this experiment")

          within ".completed_experiments" do
            expect(find(".starting_date").text).to have_content("16 Jun 2020")
            expect(find(".ending_date").text).to have_content("7 Jul 2020")
          end
        end
      end

      context "just before the 21 days have passed" do
        before do
          travel_to DateTime.parse("7 Jul 2020 22:00:00 PM")
          visit dashboard_experiments_path
        end

        after do
          travel_back
        end

        it "does not yet show the call to action just before the 21 days have passed" do
          expect(page).to_not have_content("You completed your experiment")
        end
      end
    end
  end

  context "When logged in as a user from the Netherlands" do
    # The Netherlands is GMT+2(summer)/GMT+1(winter)
    let(:dutch_user) { FactoryBot.create(:user, time_zone: "Amsterdam") }

    before { login_as(dutch_user) }

    context "When on the observation index page" do
      before do
        visit observations_path
      end

      context "when selecting a date for the new observation" do
        it "correctly autoselects today" do
          expect(page).to have_select("date", selected: "17 Jun 2020 (Wed)")
        end
      end

      context "when viewing the created observations in the last 14 days" do
        it "already lists the 17th as that is today to the Dutch user" do
          within(".past_observations") do
            expect(page).to have_content("17 Jun (Wed)")
          end
        end
      end
    end

    context "When on the observation create page" do
      before do
        visit observations_path
        click_button("New observation")
      end

      it "displays the correct date in the header" do
        within ".jumbotron" do
          expect(page).to have_content("17 Jun")
        end
      end

      it "shows the correct date of this observation on the index page after saving" do
        choose("observation_mood_3")
        choose("observation_sleep_3")
        choose("observation_health_3")
        choose("observation_relax_3")
        choose("observation_connect_3")
        choose("observation_meaning_3")

        click_button "Save observation"
        visit observations_path

        within ".date-2020-06-17" do
          expect(page).to have_css(".fa-check")
        end
      end
    end

    context "When on the dashboard page" do
      context "when no observation exists for today" do
        it "has a call to action to fill it in" do
          visit observations_path
          select("16 Jun 2020 (Tue)", from: "date")
          click_button("New observation")

          choose("observation_mood_3")
          choose("observation_sleep_3")
          choose("observation_health_3")
          choose("observation_relax_3")
          choose("observation_connect_3")
          choose("observation_meaning_3")

          click_button "Save observation"

          visit dashboard_lab_path
          expect(page).to have_content("I want to keep track of how I'm feeling")
        end
      end

      context "when the observation exists for today" do
        it "shows the user it has been filled in" do
          visit observations_path
          click_button("New observation")

          choose("observation_mood_3")
          choose("observation_sleep_3")
          choose("observation_health_3")
          choose("observation_relax_3")
          choose("observation_connect_3")
          choose("observation_meaning_3")

          click_button "Save observation"

          visit dashboard_lab_path
          expect(page).to have_content("You've added your observation for today.")
        end
      end
    end

    context "When starting an experiment" do
      let(:category) { FactoryBot.create(:category) }
      let(:experiment) { FactoryBot.create(:experiment, category: category) }

      context "when starting today" do
        before do
          visit experiment_path(id: experiment.slug, category: category)
          click_link "Start this experiment"
          select("Today", from: "experiment_user_starting_date")
          all(class: "experiment_user_experiment_user_measurements_starting_score").each do |score|
            score.choose(class: "radio_buttons", option: "4")
          end
          click_button "Start this experiment"
        end

        it "shows the correct starting/ending dates on the experiment show page" do
          visit dashboard_experiments_path

          within ".current_experiment" do
            expect(page).to have_content experiment.name
            expect(find(".starting_date").text).to have_content("17 Jun")
            expect(find(".ending_date").text).to have_content("8 Jul")
          end
        end

        it "shows the correct starting/ending dates on the lab page" do
          visit dashboard_lab_path

          within ".phases" do
            expect(page).to have_content "From 17 Jun (Wed) to 8 Jul (Wed)"
          end
        end

        it "shows the experiment when creating a observation" do
          visit observations_path
          click_button("New observation")

          expect(page).to have_content experiment.name
        end

        context "#active_experiment_day_counter" do
          xit "correctly shows the user is on day 1 of the experiment" do
            visit dashboard_lab_path
            expect(page).to have_content "You're on day 1"
          end

          context "when the next day starts in local time" do
            before do
              travel_to DateTime.parse("17th Jun 2020 23:00:00 PM")
            end

            after do
              travel_back
            end

            xit "increases the counter at the correct local time" do
              visit dashboard_lab_path
              expect(page).to have_content "You're on day 2"
            end
          end
        end
      end

      context "when starting tomorrow" do
        before do
          visit experiment_path(id: experiment.slug, category: category)
          click_link "Start this experiment"
          select("Tomorrow", from: "experiment_user_starting_date")
          all(class: "experiment_user_experiment_user_measurements_starting_score").each do |score|
            score.choose(class: "radio_buttons", option: "4")
          end
          click_button "Start this experiment"
        end

        it "shows the correct starting/ending dates on the experiment show page" do
          visit dashboard_experiments_path

          within ".current_experiment" do
            expect(page).to have_content experiment.name
            expect(find(".starting_date").text).to have_content("18 Jun")
            expect(find(".ending_date").text).to have_content("9 Jul")
          end
        end

        it "shows the correct starting/ending dates on the lab page" do
          visit dashboard_lab_path

          within ".phases" do
            expect(page).to have_content "From 18 Jun (Thu) to 9 Jul (Thu)"
          end
        end

        it "does not yet show the experiment when creating a observation" do
          visit observations_path
          click_button("New observation")

          expect(page).to_not have_content experiment.name
        end

        context "#active_experiment_on_date(date)" do
          context "just before the next day starts in local time" do
            before do
              travel_to DateTime.parse("17th Jun 2020 21:00:00 PM")
            end

            after do
              travel_back
            end

            it "does not show the experiment when creating a new observation" do
              visit observations_path
              click_button("New observation")

              expect(page).to_not have_content experiment.name
            end
          end

          context "when the next day starts in local time" do
            before do
              travel_to DateTime.parse("17th Jun 2020 23:00:00 PM")
            end

            after do
              travel_back
            end

            it "does show the experiment when creating a new observation" do
              visit observations_path
              click_button("New observation")

              expect(page).to have_content experiment.name
            end
          end
        end

        context "#active_experiment_day_counter" do
          xit "correctly shows the user is on day 1 of the experiment" do
            visit dashboard_lab_path
            expect(page).to have_content "You're on day 0"
          end

          context "when the next day starts in local time" do
            before do
              travel_to DateTime.parse("17th Jun 2020 23:00:00 PM")
            end

            after do
              travel_back
            end

            xit "increases the counter at the correct local time" do
              visit dashboard_lab_path
              expect(page).to have_content "You're on day 1"
            end
          end
        end
      end
    end

    context "When canceling an experiment" do
      let(:category) { FactoryBot.create(:category) }
      let(:experiment) { FactoryBot.create(:experiment, category: category) }

      before do
        visit experiment_path(id: experiment.slug, category: category)
        click_link "Start this experiment"
        select("Today", from: "experiment_user_starting_date")
        all(class: "experiment_user_experiment_user_measurements_starting_score").each do |score|
          score.choose(class: "radio_buttons", option: "4")
        end
        click_button "Start this experiment"
        travel_to DateTime.parse("23rd Jun 2020 23:00:00 PM")
      end

      after do
        travel_back
      end

      it "shows the correct starting/ending dates on the experiment show page" do
        visit dashboard_experiments_path
        click_link "Cancel experiment"
        click_button "Stop this experiment"

        within ".cancelled_experiments" do
          expect(find(".starting_date").text).to have_content("17 Jun 2020")
          expect(find(".ending_date").text).to have_content("24 Jun 2020")
        end
      end
    end

    context "When completing an experiment" do
      let(:category) { FactoryBot.create(:category) }
      let(:experiment) { FactoryBot.create(:experiment, category: category) }

      before do
        visit experiment_path(id: experiment.slug, category: category)
        click_link "Start this experiment"
        select("Today", from: "experiment_user_starting_date")
        all(class: "experiment_user_experiment_user_measurements_starting_score").each do |score|
          score.choose(class: "radio_buttons", option: "4")
        end
        click_button "Start this experiment"
        travel_to DateTime.parse("8 Jul 2020 23:00:00 PM")
        visit dashboard_experiments_path
      end

      after do
        travel_back
      end

      context "after 21 days" do
        it "shows the call to action to complete the experiment" do
          expect(page).to have_content("You completed your experiment")
        end

        it "shows the correct starting/ending dates for observations" do
          click_link "Finalize experiment"

          within ".during_dates" do
            expect(page).to have_content("17 Jun")
            expect(page).to have_content("8 Jul")
          end

          within ".before_dates" do
            expect(page).to have_content("16 Jun")
          end
        end

        it "shows the correct starting/ending dates on the experiment show page upon completion" do
          click_link "Finalize experiment"
          all(class: "experiment_user_experiment_user_measurements_ending_score").each do |score|
            score.choose(class: "radio_buttons", option: "4")
          end
          select("Very easy", from: "experiment_user_difficulty")
          select("Moderate", from: "experiment_user_life_impact")
          click_button("Complete this experiment")

          within ".completed_experiments" do
            expect(find(".starting_date").text).to have_content("17 Jun 2020")
            expect(find(".ending_date").text).to have_content("8 Jul 2020")
          end
        end
      end

      context "just before the 21 days have passed" do
        before do
          travel_to DateTime.parse("8 Jul 2020 20:00:00 PM")
          visit dashboard_experiments_path
        end

        after do
          travel_back
        end

        it "does not yet show the call to action just before the 21 days have passed" do
          expect(page).to_not have_content("You completed your experiment")
        end
      end
    end
  end
end
