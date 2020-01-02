require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /users/sign_up" do
    it "returns the page successfully" do
      get new_user_registration_path
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /users/sign_in" do
    it "returns the page successfully" do
      get new_user_session_path
      expect(response).to have_http_status(200)
    end
  end
end
