# frozen_string_literal: true

require "rails_helper"

RSpec.describe SendGoogleAnalyticsEventJob, type: :job do
  include ActiveJob::TestHelper

  context "sending the event to Google Analytics" do
    let(:subject) { SendGoogleAnalyticsEventJob }
    let(:enqueued_jobs) { ActiveJob::Base.queue_adapter.enqueued_jobs }
    let(:event_params) do
      {
        v: 1,
        tid: (GOOGLE_ANALYTICS_SETTINGS[:tracking_code]).to_s,
        cid: "555",
        t: "event",
        ec: "blog_comment",
        ea: "creation",
        el: "a_blog_slug"
      }
    end

    before do
      stub_request(:post, (GOOGLE_ANALYTICS_SETTINGS[:endpoint]).to_s)
    end

    context "when an event is triggered" do
      it "does a POST request to GA" do
        subject.perform_now(event_params)

        expect(a_request(:post, (GOOGLE_ANALYTICS_SETTINGS[:endpoint]).to_s)).to have_been_made.once
      end
    end
  end
end
