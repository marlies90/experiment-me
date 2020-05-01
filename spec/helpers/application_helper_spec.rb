# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationHelper, type: :helper do
  describe "#to_journal_date" do
    it "returns the date in the correct format" do
      expect(helper.to_journal_date(DateTime.new(2020, 1, 14))).to eq("14 Jan 2020 (Tue)")
    end
  end

  describe "#to_journal_date_no_year" do
    it "returns the date in the correct format" do
      expect(helper.to_journal_date_no_year(DateTime.new(2020, 1, 14))).to eq("14 Jan (Tue)")
    end
  end
end
