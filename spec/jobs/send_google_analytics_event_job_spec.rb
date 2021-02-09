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
        tid: "UA",
        cid: "555",
        t: "event",
        ec: "f",
        ea: "d",
        el: "f"
      }
    end

    context "when the experiment started 10 days ago" do
      it "schedules the email" do
        subject.perform_later(event_params)

        expect(enqueued_jobs.last["job_class"]).to eq("SendGoogleAnalyticsEventJob")
        expect(enqueued_jobs.size).to be 1
      end
    end
  end
end
