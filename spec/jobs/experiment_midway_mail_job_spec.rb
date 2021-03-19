# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExperimentMidwayMailJob, type: :job do
  include ActiveJob::TestHelper

  context "selecting the right users to mail" do
    let(:subject) { ExperimentMidwayMailJob }
    let(:enqueued_jobs) { ActiveJob::Base.queue_adapter.enqueued_jobs }

    context "when the experiment started 10 days ago" do
      context "when the mail_preference is active" do
        let!(:experiment_user) do
          FactoryBot.create(:experiment_user, :active, starting_date: 10.days.ago)
        end

        it "sends the email" do
          subject.perform_now

          expect(enqueued_jobs.last["arguments"]).to include("experiment_midway_email")
          expect(enqueued_jobs.size).to be 1
        end
      end

      context "when the mail_preference is inactive" do
        let(:user) { FactoryBot.create(:user) }

        let!(:experiment_user) do
          FactoryBot.create(:experiment_user, :active, starting_date: 10.days.ago, user: user)
        end

        let!(:mail_preference) do
          FactoryBot.create(:mail_preference, :inactive, :experiment_midway, user: user)
        end

        it "does not send the email" do
          subject.perform_now

          expect(enqueued_jobs.size).to be 0
        end
      end
    end

    context "when the experiment started 10 days ago but not exactly" do
      let!(:experiment_user) do
        FactoryBot.create(:experiment_user, :active, starting_date: 10.days.ago + 2.hours)
      end

      it "sends the email" do
        subject.perform_now

        expect(enqueued_jobs.last["arguments"]).to include("experiment_midway_email")
        expect(enqueued_jobs.size).to be 1
      end
    end

    context "when the experiment started 9 days ago" do
      let!(:experiment_user) do
        FactoryBot.create(:experiment_user, :active, starting_date: 9.days.ago)
      end

      it "does not send the email" do
        subject.perform_now

        expect(enqueued_jobs.size).to be 0
      end
    end

    context "when the experiment started 11 days ago" do
      let!(:experiment_user) do
        FactoryBot.create(:experiment_user, :active, starting_date: 11.days.ago)
      end

      it "does not send the email" do
        subject.perform_now

        expect(enqueued_jobs.size).to be 0
      end
    end

    context "when the experiment has been cancelled in the meantime" do
      let!(:experiment_user) do
        FactoryBot.create(:experiment_user, :cancelled, starting_date: 10.days.ago)
      end

      it "does not send the email" do
        subject.perform_now

        expect(enqueued_jobs.size).to be 0
      end
    end
  end
end
