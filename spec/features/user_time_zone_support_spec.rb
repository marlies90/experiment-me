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

    context "When on the journal_entry index page" do
      before do
        visit journal_entries_path
      end

      context "when selecting a date for the new journal entry" do
        it "correctly autoselects today" do
          expect(page).to have_select("date", selected: "16 Jun 2020 (Tue)")
        end
      end

      context "when viewing the created journal entries in the last 14 days" do
        it "doesn't yet list the 17th as that is tomorrow to the Alaskan user" do
          within(".table-responsive") do
            expect(page).to_not have_content("17 Jun (Wed)")
          end
        end
      end
    end

    context "When on the journal_entry create page" do
      before do
        visit journal_entries_path
        click_button("New journal entry")
      end

      it "displays the correct date in the header" do
        within "h1" do
          expect(page).to have_content("16 Jun")
        end
      end

      it "shows the correct date of this journal_entry on the index page after saving" do
        choose("journal_entry_mood_3")
        choose("journal_entry_sleep_3")
        choose("journal_entry_health_3")
        choose("journal_entry_relax_3")
        choose("journal_entry_connect_3")
        choose("journal_entry_meaning_3")

        click_button "Save journal entry"

        within ".date-2020-06-16" do
          expect(page).to have_content("3", count: 6)
        end
      end
    end

    context "When on the dashboard page" do
      context "when no journal_entry exists for today" do
        it "has a call to action to fill it in" do
          visit journal_entries_path
          select("15 Jun 2020 (Mon)", from: "date")
          click_button("New journal entry")

          choose("journal_entry_mood_3")
          choose("journal_entry_sleep_3")
          choose("journal_entry_health_3")
          choose("journal_entry_relax_3")
          choose("journal_entry_connect_3")
          choose("journal_entry_meaning_3")

          click_button "Save journal entry"

          visit dashboard_overview_path
          expect(page).to have_content("Rate your day in your journal.")
        end
      end

      context "when the journal_entry exists for today" do
        it "shows the user it has been filled in" do
          visit journal_entries_path
          click_button("New journal entry")

          choose("journal_entry_mood_3")
          choose("journal_entry_sleep_3")
          choose("journal_entry_health_3")
          choose("journal_entry_relax_3")
          choose("journal_entry_connect_3")
          choose("journal_entry_meaning_3")

          click_button "Save journal entry"

          visit dashboard_overview_path
          expect(page).to have_content("You've filled in your entry for today")
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
            expect(find(".starting_date").text).to have_content("16 Jun 2020")
            expect(find(".ending_date").text).to have_content("7 Jul 2020")
          end
        end

        it "shows the experiment when creating a journal_entry" do
          visit journal_entries_path
          click_button("New journal entry")

          expect(page).to have_content experiment.name
        end

        context "#active_experiment_day_counter" do
          it "correctly shows the user is on day 1 of the experiment" do
            visit dashboard_overview_path
            expect(page).to have_content "You're on day 1"
          end

          context "when the next day starts in local time" do
            before do
              travel_to DateTime.parse("17th Jun 2020 08:00:00 AM")
            end

            after do
              travel_back
            end

            it "increases the counter at the correct local time" do
              visit dashboard_overview_path
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
            expect(find(".starting_date").text).to have_content("17 Jun 2020")
            expect(find(".ending_date").text).to have_content("8 Jul 2020")
          end
        end

        it "does not yet show the experiment when creating a journal_entry" do
          visit journal_entries_path
          click_button("New journal entry")

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

            it "does not show the experiment when creating a new journal_entry" do
              visit journal_entries_path
              click_button("New journal entry")

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

            it "does show the experiment when creating a new journal_entry" do
              visit journal_entries_path
              click_button("New journal entry")

              expect(page).to have_content experiment.name
            end
          end
        end

        context "#active_experiment_day_counter" do
          it "correctly shows the user is on day 1 of the experiment" do
            visit dashboard_overview_path
            expect(page).to have_content "You're on day 0"
          end

          context "when the next day starts in local time" do
            before do
              travel_to DateTime.parse("17th Jun 2020 08:00:00 AM")
            end

            after do
              travel_back
            end

            it "increases the counter at the correct local time" do
              visit dashboard_overview_path
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
        click_link "Stop experiment"
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
          expect(page).to have_content("YAY! You completed your experiment")
        end

        it "shows the correct starting/ending dates on the experiment show page upon completion" do
          click_link "Evaluate experiment"
          all(class: "experiment_user_experiment_user_measurements_ending_score").each do |score|
            score.choose(class: "radio_buttons", option: "4")
          end
          select("Very easy", from: "experiment_user_difficulty")
          select("Moderate", from: "experiment_user_life_impact")
          click_button("Evaluate this experiment")

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
          expect(page).to_not have_content("YAY! You completed your experiment")
        end
      end
    end
  end

  context "When logged in as a user from the Netherlands" do
    # The Netherlands is GMT+2(summer)/GMT+1(winter)
    let(:dutch_user) { FactoryBot.create(:user, time_zone: "Amsterdam") }

    before { login_as(dutch_user) }

    context "When on the journal_entry index page" do
      before do
        visit journal_entries_path
      end

      context "when selecting a date for the new journal entry" do
        it "correctly autoselects today" do
          expect(page).to have_select("date", selected: "17 Jun 2020 (Wed)")
        end
      end

      context "when viewing the created journal entries in the last 14 days" do
        it "already lists the 17th as that is today to the Dutch user" do
          within(".table-responsive") do
            expect(page).to have_content("17 Jun (Wed)")
          end
        end
      end
    end

    context "When on the journal_entry create page" do
      before do
        visit journal_entries_path
        click_button("New journal entry")
      end

      it "displays the correct date in the header" do
        within "h1" do
          expect(page).to have_content("17 Jun")
        end
      end

      it "shows the correct date of this journal_entry on the index page after saving" do
        choose("journal_entry_mood_3")
        choose("journal_entry_sleep_3")
        choose("journal_entry_health_3")
        choose("journal_entry_relax_3")
        choose("journal_entry_connect_3")
        choose("journal_entry_meaning_3")

        click_button "Save journal entry"

        within ".date-2020-06-17" do
          expect(page).to have_content("3", count: 6)
        end
      end
    end

    context "When on the dashboard page" do
      context "when no journal_entry exists for today" do
        it "has a call to action to fill it in" do
          visit journal_entries_path
          select("16 Jun 2020 (Tue)", from: "date")
          click_button("New journal entry")

          choose("journal_entry_mood_3")
          choose("journal_entry_sleep_3")
          choose("journal_entry_health_3")
          choose("journal_entry_relax_3")
          choose("journal_entry_connect_3")
          choose("journal_entry_meaning_3")

          click_button "Save journal entry"

          visit dashboard_overview_path
          expect(page).to have_content("Rate your day in your journal.")
        end
      end

      context "when the journal_entry exists for today" do
        it "shows the user it has been filled in" do
          visit journal_entries_path
          click_button("New journal entry")

          choose("journal_entry_mood_3")
          choose("journal_entry_sleep_3")
          choose("journal_entry_health_3")
          choose("journal_entry_relax_3")
          choose("journal_entry_connect_3")
          choose("journal_entry_meaning_3")

          click_button "Save journal entry"

          visit dashboard_overview_path
          expect(page).to have_content("You've filled in your entry for today")
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
            expect(find(".starting_date").text).to have_content("17 Jun 2020")
            expect(find(".ending_date").text).to have_content("8 Jul 2020")
          end
        end

        it "shows the experiment when creating a journal_entry" do
          visit journal_entries_path
          click_button("New journal entry")

          expect(page).to have_content experiment.name
        end

        context "#active_experiment_day_counter" do
          it "correctly shows the user is on day 1 of the experiment" do
            visit dashboard_overview_path
            expect(page).to have_content "You're on day 1"
          end

          context "when the next day starts in local time" do
            before do
              travel_to DateTime.parse("17th Jun 2020 23:00:00 PM")
            end

            after do
              travel_back
            end

            it "increases the counter at the correct local time" do
              visit dashboard_overview_path
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
            expect(find(".starting_date").text).to have_content("18 Jun 2020")
            expect(find(".ending_date").text).to have_content("9 Jul 2020")
          end
        end

        it "does not yet show the experiment when creating a journal_entry" do
          visit journal_entries_path
          click_button("New journal entry")

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

            it "does not show the experiment when creating a new journal_entry" do
              visit journal_entries_path
              click_button("New journal entry")

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

            it "does show the experiment when creating a new journal_entry" do
              visit journal_entries_path
              click_button("New journal entry")

              expect(page).to have_content experiment.name
            end
          end
        end

        context "#active_experiment_day_counter" do
          it "correctly shows the user is on day 1 of the experiment" do
            visit dashboard_overview_path
            expect(page).to have_content "You're on day 0"
          end

          context "when the next day starts in local time" do
            before do
              travel_to DateTime.parse("17th Jun 2020 23:00:00 PM")
            end

            after do
              travel_back
            end

            it "increases the counter at the correct local time" do
              visit dashboard_overview_path
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
        click_link "Stop experiment"
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
          expect(page).to have_content("YAY! You completed your experiment")
        end

        it "shows the correct starting/ending dates on the experiment show page upon completion" do
          click_link "Evaluate experiment"
          all(class: "experiment_user_experiment_user_measurements_ending_score").each do |score|
            score.choose(class: "radio_buttons", option: "4")
          end
          select("Very easy", from: "experiment_user_difficulty")
          select("Moderate", from: "experiment_user_life_impact")
          click_button("Evaluate this experiment")

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
          expect(page).to_not have_content("YAY! You completed your experiment")
        end
      end
    end
  end
end
