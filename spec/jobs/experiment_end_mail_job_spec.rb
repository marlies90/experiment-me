# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExperimentEndMailJob, type: :job do
  include ActiveJob::TestHelper

  context "selecting the right users to mail" do
    let(:subject) { ExperimentEndMailJob }
    let(:enqueued_jobs) { ActiveJob::Base.queue_adapter.enqueued_jobs }

    context "when the experiment ended in the last 12 hours" do
      let!(:experiment_user) do
        FactoryBot.create(:experiment_user, :active, ending_date: 11.hours.ago + 59.minutes)
      end

      it "sends the email" do
        subject.perform_now

        expect(enqueued_jobs.last["arguments"]).to include("experiment_end_email")
        expect(enqueued_jobs.size).to be 1
      end
    end

    context "when the experiment ended 6 hours ago" do
      let!(:experiment_user) do
        FactoryBot.create(:experiment_user, :active, ending_date: 6.hours.ago)
      end

      it "sends the email" do
        subject.perform_now

        expect(enqueued_jobs.last["arguments"]).to include("experiment_end_email")
        expect(enqueued_jobs.size).to be 1
      end
    end

    context "when the experiment ended 13 hours ago" do
      let!(:experiment_user) do
        FactoryBot.create(:experiment_user, :active, ending_date: 13.hours.ago)
      end

      it "does not send the email" do
        subject.perform_now

        expect(enqueued_jobs.size).to be 0
      end
    end

    context "when the experiment has already been completed in the meantime" do
      let!(:experiment_user) do
        FactoryBot.create(:experiment_user, :completed, starting_date: 10.hours.ago)
      end

      it "does not send the email" do
        subject.perform_now

        expect(enqueued_jobs.size).to be 0
      end
    end
  end
end
