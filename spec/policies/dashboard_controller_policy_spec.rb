require 'rails_helper'

RSpec.describe DashboardControllerPolicy do
  subject { DashboardPolicy.new(user, self) }

  context "When not logged in" do
    let(:user) { nil }

    it { should forbid_actions(%i[overview settings journal progress admin]) }
  end

  context "When logged in as a standard user" do
    let(:user) { FactoryBot.create(:user) }

    it { should permit_actions(%i[overview settings journal progress]) }
    it { should forbid_actions(%i[admin]) }
  end

  context "When logged in as an admin user" do
    let(:user) { FactoryBot.create(:user, :admin) }

    it { should permit_actions(%i[overview settings journal progress admin]) }
  end
end
