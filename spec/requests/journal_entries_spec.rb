require 'rails_helper'

RSpec.describe "Journal Entries", type: :request do
  describe "GET /dashboard/journal" do
    let(:user) { build(:user) }

    before do
      sign_in(user)
    end

    it "returns the page successfully" do
      get journal_entries_path
      expect(response).to have_http_status(200)
    end
  end
end
