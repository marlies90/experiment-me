# frozen_string_literal: true

require "rails_helper"

RSpec.describe DashboardControllerPolicy do
  subject { DashboardControllerPolicy.new(user, self) }

  context "When not logged in" do
    let(:user) { nil }

    it { should forbid_actions(%i[lab settings journal charts admin]) }
  end

  context "When logged in as a standard user" do
    let(:user) { FactoryBot.create(:user) }

    it { should permit_actions(%i[lab settings journal charts]) }
    it { should forbid_actions(%i[admin]) }
  end

  context "When logged in as an admin user" do
    let(:user) { FactoryBot.create(:user, :admin) }

    it { should permit_actions(%i[lab settings journal charts admin]) }
  end
end
