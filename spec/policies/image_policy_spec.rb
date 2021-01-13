# frozen_string_literal: true

require "rails_helper"

RSpec.describe ImagePolicy do
  subject { ImagePolicy.new(user, image) }
  let(:image) { FactoryBot.create(:image) }

  context "When not logged in" do
    let(:user) { nil }

    it { should forbid_actions(%i[create new update edit destroy]) }
  end

  context "When logged in as a standard user" do
    let(:user) { FactoryBot.create(:user) }

    it { should forbid_actions(%i[create new update edit destroy]) }
  end

  context "When logged in as an admin user" do
    let(:user) { FactoryBot.create(:user, :admin) }

    it { should permit_actions(%i[create new update edit destroy]) }
  end
end
