require 'rails_helper'

RSpec.describe CategoryPolicy do
  subject { CategoryPolicy.new(user, category) }
  let(:category) { FactoryBot.create(:category) }

  context "When not logged in" do
    let(:user) { nil }

    it { should permit_actions(%i[show index]) }
    it { should forbid_actions(%i[create new update edit destroy]) }
  end

  context "When logged in as a standard user" do
    let(:user) { FactoryBot.create(:user) }

    it { should permit_actions(%i[show index]) }
    it { should forbid_actions(%i[create new update edit destroy]) }
  end

  context "When logged in as an admin user" do
    let(:user) { FactoryBot.create(:user, :admin) }

    it { should permit_actions(%i[show index create new update edit destroy]) }
  end
end
