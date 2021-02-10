# frozen_string_literal: true

require "rails_helper"

RSpec.describe Observation, type: :feature do
  let(:current_user) { FactoryBot.create(:user) }

  before do
    login_as(current_user)
    visit observations_path
  end

  context "when selecting a date" do
    context "when no other observation has been created yet" do
      it "auto-selects today in the date picker" do
        expect(page).to have_select("date", selected: DateTime.current.beginning_of_day)
      end

      it "shows that there are no observations for the past 7 days" do
        expect(page).to have_css(".fa-times", count: 7)
      end
    end

    context "when there is already a observation for today" do
      let!(:observation) { FactoryBot.create(:observation, user: current_user) }

      before do
        visit observations_path
      end

      it "auto-selects yesterday when the entry for today has already been created" do
        expect(page).to have_select("date", selected: DateTime.current.beginning_of_day - 1)
      end

      it "shows that there is one observation" do
        within(".past_observations") do
          expect(page).to have_css(".edit_observation")
        end
        expect(page).to have_css(".fa-times", count: 6)
      end
    end
  end

  context "when creating a new observation" do
    before do
      click_button("New observation")
    end

    it "sends an event to Google Analytics" do
      event = spy(GoogleAnalyticsEvent)
      expect(GoogleAnalyticsEvent).to receive(:new).and_return(event)

      choose("observation_mood_3")
      choose("observation_sleep_3")
      choose("observation_health_3")
      choose("observation_relax_3")
      choose("observation_connect_3")
      choose("observation_meaning_3")

      click_button "Save observation"
    end
  end

  context "without an active experiment" do
    context "when creating a new observation" do
      before do
        click_button("New observation")
      end

      it "allows a valid observation to be created succesfully" do
        choose("observation_mood_3")
        choose("observation_sleep_3")
        choose("observation_health_3")
        choose("observation_relax_3")
        choose("observation_connect_3")
        choose("observation_meaning_3")

        click_button "Save observation"
        expect(page).to have_content "Your observation has been saved."
      end

      it "does not allow a observation to be created without filling in all ratings" do
        choose("observation_sleep_3")

        click_button "Save observation"
        expect(page).to have_content(
          "The observation is incomplete and can therefore not be saved"
        )
        expect(page).to have_content "Meaning can't be blank"
      end

      it "does not allow a observation to be created when 0 ratings have been filled in" do
        click_button "Save observation"
        expect(page).to have_content(
          "The observation is incomplete and can therefore not be saved"
        )
        expect(page).to have_content "Mood can't be blank"
      end
    end

    context "when a observation has been created" do
      let!(:observation) { FactoryBot.create(:observation, user: current_user) }

      before do
        visit observations_path
      end

      it "allows the user to go into editing mode" do
        find(class: "edit_observation").click
        expect(page).to have_css ".radio_buttons"
      end

      it "allows the user to update that observation" do
        find(class: "edit_observation").click
        choose("observation_mood_3")
        choose("observation_sleep_3")
        choose("observation_health_3")
        choose("observation_relax_3")
        choose("observation_connect_3")
        choose("observation_meaning_3")
        click_button("Save observation")
        expect(page).to have_content "Your observation has been updated."
      end

      it "allows the user to destroy that observation" do
        find(class: "edit_observation").click
        find(class: "destroy_observation").click
        expect(page).to have_content "Your observation has been deleted"
      end

      it "shows the details on the charts page" do
        visit dashboard_charts_path
        expect(page).to have_content observation.note
      end
    end
  end

  context "with an active experiment" do
    let!(:experiment_user) { create(:experiment_user, :active, user: current_user) }
    let!(:completed_experiment_user) do
      create(
        :experiment_user,
        :completed,
        user: current_user,
        starting_date: (DateTime.current - 24).beginning_of_day,
        ending_date: (DateTime.current - 3).beginning_of_day
      )
    end

    context "when creating a new observation" do
      context "with a date on which the current experiment is active" do
        before do
          click_button("New observation")
        end

        it "displays the current experiment" do
          expect(page).to have_content "Your current experiment"
          expect(page).to have_content experiment_user.experiment.name
        end

        it "does not display the previous experiment" do
          expect(page).to_not have_content completed_experiment_user.experiment.name
        end
      end

      context "with a date on which the previous experiment was active" do
        before do
          find("#date option:last-of-type").select_option
          click_button("New observation")
        end

        it "displays the previous experiment" do
          expect(page).to have_content "Your current experiment"
          expect(page).to have_content completed_experiment_user.experiment.name
        end

        it "does not display the current experiment" do
          expect(page).to_not have_content experiment_user.experiment.name
        end
      end

      context "when submitting the form" do
        before do
          click_button("New observation")
        end

        it "allows a observation to be created when experiment_success was filled in" do
          choose("observation_experiment_success_true")
          choose("observation_mood_3")
          choose("observation_sleep_3")
          choose("observation_health_3")
          choose("observation_relax_3")
          choose("observation_connect_3")
          choose("observation_meaning_3")

          click_button "Save observation"
          expect(page).to have_content "Your observation has been saved."
        end

        it "does not allow a observation to be created without experiment_success filled in" do
          choose("observation_mood_3")
          choose("observation_sleep_3")
          choose("observation_health_3")
          choose("observation_relax_3")
          choose("observation_connect_3")
          choose("observation_meaning_3")

          click_button "Save observation"
          expect(page).to have_content(
            "The observation is incomplete and can therefore not be saved"
          )
          expect(page).to have_content "Fill in whether you stuck to the experiment"
        end
      end
    end

    context "when editing an existing observation" do
      context "with an experiment that has been completed in the meantime" do
        let!(:observation) do
          FactoryBot.create(
            :observation,
            user: current_user,
            date: (DateTime.current - 6).beginning_of_day,
            experiment_id: previous_experiment_user.experiment.id,
            experiment_success: true
          )
        end
        let(:current_experiment_user) { FactoryBot.create(:experiment_user, :active) }
        let(:previous_experiment_user) do
          create(
            :experiment_user,
            :completed,
            starting_date: (DateTime.current - 25).beginning_of_day,
            ending_date: (DateTime.current - 4).beginning_of_day
          )
        end

        before do
          visit observations_path
          find(class: "edit_observation").click
        end

        it "displays the experiment that was active on the moment the observation was created" do
          expect(page).to have_content "Your current experiment"
          expect(page).to have_content previous_experiment_user.experiment.name
        end

        it "does not display the experiment that is currently active" do
          expect(page).to_not have_content current_experiment_user.experiment.name
        end
      end
    end
  end
end
