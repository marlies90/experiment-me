require 'rails_helper'

RSpec.describe JournalEntry, type: :feature do
  let(:current_user) { FactoryBot.create(:user) }
  let!(:journal_statement) { FactoryBot.create_list(:journal_statement, 6)}

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

    context "when creating a new journal_entry" do
      before do
        click_button("New journal entry")
      end

      it "displays the current experiment" do
        expect(page).to have_content "You're currently doing the experiment"
        expect(page).to have_content experiment_user.experiment.name
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
        expect(page).to have_content "Experiment success can't be blank"
      end
    end

    context "when editing an existing journal_entry" do
      let(:journal_entry) { FactoryBot.create(:journal_entry, user: current_user) }

      before do
        visit journal_entry_path(journal_entry)
      end

      it "displays the experiment that was active on the moment the journal_entry was created" do
        
      end
    end
  end
end
