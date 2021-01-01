# frozen_string_literal: true

require "rails_helper"

RSpec.describe BlogCommentPolicy do
  subject { BlogCommentPolicy.new(user, blog_comment) }
  let(:blog_comment) { FactoryBot.create(:blog_comment, :on_blog_post) }

  context "When not logged in" do
    let(:user) { nil }

    it { should permit_actions(%i[create]) }
    it { should forbid_actions(%i[destroy]) }
  end

  context "When logged in as a standard user" do
    let(:user) { FactoryBot.create(:user) }

    it { should permit_actions(%i[create]) }
    it { should forbid_actions(%i[destroy]) }
  end

  context "When logged in as an admin user" do
    let(:user) { FactoryBot.create(:user, :admin) }

    it { should permit_actions(%i[create destroy]) }
  end
end
