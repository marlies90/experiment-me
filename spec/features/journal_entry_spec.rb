require 'rails_helper'

RSpec.describe JournalEntry, type: :feature do
  let(:user) { create(:user) }
  let!(:journal_statement) { create_list(:journal_statement, 6)}

  before do
    login_as(user)
    visit journal_entries_path
  end

  context "When creating a new journal entry" do
    before do
      click_link(class: "btn-primary")
    end

    it "Allows a valid journal_entry to be created succesfully" do
      all(class: "journal_entry_journal_ratings_score").each do |rating|
        rating.choose(class: "radio_buttons", option: "8")
      end
      click_button "Save journal entry"
      expect(page).to have_content "Journal entry was successfully created."
    end

    it "Does not allow a journal_entry to be created without filling in all ratings" do
      all(class: "journal_entry_journal_ratings_score").first do |rating|
        rating.choose(class: "radio_buttons", option: "8")
      end
      click_button "Save journal entry"
      expect(page).to have_content "errors prohibited this journal entry from being saved"
    end

    it "Does not allow a journal_entry to be created when 0 ratings have been filled in" do
      click_button "Save journal entry"
      expect(page).to have_content "errors prohibited this journal entry from being saved"
    end

    it "Auto-selects today in the date picker" do
      expect(page).to have_select("journal_entry_date", selected: DateTime.current.beginning_of_day)
    end
  end

  context "When a journal entry has been created" do
    let(:journal_entry) { create(:journal_entry, user: user) }

    before do
      visit journal_entry_path(journal_entry)
    end

    it "Allows the user to view that journal entry" do
      expect(page).to have_content "Statement"
      expect(page).to have_content "Score"
    end

    it "Allows the user to go into editing mode" do
      click_link("Edit journal entry")
      expect(page).to have_css ".radio_buttons"
    end

    it "Allows the user to update that journal entry" do
      click_link("Edit journal entry")
      all(class: "journal_entry_journal_ratings_score").each do |rating|
        rating.choose(class: "radio_buttons", option: "8")
      end
      click_button("Save journal entry")
      expect(page).to have_content "Journal entry was successfully updated."
    end

    it "Does not allow the user to update the date" do
      expect(page).to_not have_select "journal_entry_date"
    end

    it "Auto-selects yesterday when the entry for today has already been created" do
      visit journal_entries_path
      click_link(class: "btn-primary")
      expect(page).to have_select("journal_entry_date", selected: DateTime.current.beginning_of_day - 1)
    end
  end
end
