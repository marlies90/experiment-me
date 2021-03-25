# frozen_string_literal: true

require "rails_helper"

RSpec.describe NewBlogCommentMailJob, type: :job do
  include ActiveJob::TestHelper

  context "sending the email only when needed" do
    let(:subject) { NewBlogCommentMailJob }
    let(:enqueued_jobs) { ActiveJob::Base.queue_adapter.enqueued_jobs }

    context "when a new blog comment was created today" do
      let!(:blog_comment) do
        FactoryBot.create(:blog_comment, :on_blog_post, created_at: 8.hours.ago)
      end

      it "sends the email" do
        subject.perform_now

        expect(enqueued_jobs.last["arguments"]).to include("new_blog_comment_email")
        expect(enqueued_jobs.size).to be 1
      end
    end

    context "when there was a comment yesterday but not today" do
      let!(:blog_comment) do
        FactoryBot.create(:blog_comment, :on_blog_post, created_at: 25.hours.ago)
      end

      it "does not send the email" do
        subject.perform_now

        expect(enqueued_jobs.size).to be 0
      end
    end
  end
end
