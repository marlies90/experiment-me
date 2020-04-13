# frozen_string_literal: true

require "rails_helper"

RSpec.describe JournalEntry, type: :feature do
  let(:current_user) { FactoryBot.create(:user) }
  let!(:journal_statement) { FactoryBot.create_list(:journal_statement, 6) }

  before do
    login_as(current_user)
    visit journal_entries_path
  end

  context "when selecting a date" do
    context "when no other journal_entry has been created yet" do
      it "auto-selects today in the date picker" do
        expect(page).to have_select("date", selected: DateTime.current.beginning_of_day)
      end
    end

    context "when there is already a journal_entry for today" do
      let!(:journal_entry) { FactoryBot.create(:journal_entry, user: current_user) }

      it "auto-selects yesterday when the entry for today has already been created" do
        visit journal_entries_path
        expect(page).to have_select("date", selected: DateTime.current.beginning_of_day - 1)
      end
    end
  end

  context "without an active experiment" do
    context "when creating a new journal_entry" do
      before do
        click_button("New journal entry")
      end

      it "allows a valid journal_entry to be created succesfully" do
        all(class: "journal_entry_journal_ratings_score").each do |rating|
          rating.choose(class: "radio_buttons", option: "8")
        end

        click_button "Save journal entry"
        expect(page).to have_content "Journal entry was successfully created."
      end

      it "does not allow a journal_entry to be created without filling in all ratings" do
        all(class: "journal_entry_journal_ratings_score").first do |rating|
          rating.choose(class: "radio_buttons", option: "8")
        end
        click_button "Save journal entry"
        expect(page).to have_content "prohibited this journal entry from being saved"
        expect(page).to have_content "Journal ratings score can't be blank"
      end

      it "does not allow a journal_entry to be created when 0 ratings have been filled in" do
        click_button "Save journal entry"
        expect(page).to have_content "prohibited this journal entry from being saved"
        expect(page).to have_content "Journal ratings score can't be blank"
      end
    end

    context "when a journal entry has been created" do
      let(:journal_entry) { FactoryBot.create(:journal_entry, user: current_user) }

      before do
        visit journal_entry_path(journal_entry)
      end

      it "allows the user to view that journal entry" do
        expect(page).to have_content "Statement"
        expect(page).to have_content "Score"
      end

      it "allows the user to go into editing mode" do
        click_link("Edit journal entry")
        expect(page).to have_css ".radio_buttons"
      end

      it "allows the user to update that journal entry" do
        click_link("Edit journal entry")
        all(class: "journal_entry_journal_ratings_score").each do |rating|
          rating.choose(class: "radio_buttons", option: "8")
        end
        click_button("Save journal entry")
        expect(page).to have_content "Journal entry was successfully updated."
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

    context "when creating a new journal_entry" do
      context "with a date on which the current experiment is active" do
        before do
          click_button("New journal entry")
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
          click_button("New journal entry")
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
          click_button("New journal entry")
        end

        it "allows a journal_entry to be created when experiment_success was filled in" do
          choose("journal_entry_experiment_success_true")
          all(class: "journal_entry_journal_ratings_score").each do |rating|
            rating.choose(class: "radio_buttons", option: "8")
          end

          click_button "Save journal entry"
          expect(page).to have_content "Journal entry was successfully created."
        end

        it "does not allow a journal_entry to be created without experiment_success filled in" do
          all(class: "journal_entry_journal_ratings_score").each do |rating|
            rating.choose(class: "radio_buttons", option: "8")
          end

          click_button "Save journal entry"
          expect(page).to have_content "prohibited this journal entry from being saved"
          expect(page).to have_content "Fill in whether you stuck to the experiment"
        end
      end
    end

    context "when editing an existing journal_entry" do
      context "with an experiment that has been completed in the meantime" do
        let(:journal_entry) do
          FactoryBot.create(
            :journal_entry,
            user: current_user,
            date: (DateTime.current - 35).beginning_of_day,
            experiment_id: previous_experiment_user.experiment.id,
            experiment_success: true
          )
        end
        let(:current_experiment_user) { FactoryBot.create(:experiment_user, :active) }
        let(:previous_experiment_user) do
          create(
            :experiment_user,
            :completed,
            starting_date: (DateTime.current - 50).beginning_of_day,
            ending_date: (DateTime.current - 29).beginning_of_day
          )
        end

        before do
          visit journal_entry_path(journal_entry)
          click_link("Edit journal entry")
        end

        it "displays the experiment that was active on the moment the journal_entry was created" do
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
