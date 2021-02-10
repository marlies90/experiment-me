# frozen_string_literal: true

require "rails_helper"

RSpec.describe GoogleAnalyticsEvent do
  include ActiveJob::TestHelper

  subject { described_class }
  let(:blog_post) { FactoryBot.create(:blog_post) }
  let!(:event) do
    subject.new(
      "Blog comment",
      "Creation",
      blog_post.slug.to_s,
      "3423422.4324222"
    ).event
  end
  let(:enqueued_jobs) { ActiveJob::Base.queue_adapter.enqueued_jobs }

  context "Creating a new event" do
    context "when tracking_code is present" do
      it "enqueues a SendGoogleAnalyticsEventJob" do
        expect(enqueued_jobs.last["job_class"]).to eq("SendGoogleAnalyticsEventJob")
        expect(enqueued_jobs.size).to be 1
      end

      it "sends the correct params" do
        expect(enqueued_jobs.last[:args].last).to eq(
          {
            "v" => 1,
            "tid" => (GOOGLE_ANALYTICS_SETTINGS[:tracking_code]).to_s,
            "cid" => "3423422.4324222",
            "t" => "event",
            "ec" => "Blog comment",
            "ea" => "Creation",
            "el" => blog_post.slug.to_s,
            "_aj_symbol_keys" => %w[v tid cid t ec ea el]
          }
        )
      end

      context "when the client_id is empty" do
        let!(:event) do
          subject.new(
            "Blog comment",
            "Creation",
            blog_post.slug.to_s,
            ""
          ).event
        end

        it "sets the client_id to 555 (GA protocol for anonymous user)" do
          expect(enqueued_jobs.last[:args].last["cid"]).to eq "555"
        end
      end
    end
  end
end
