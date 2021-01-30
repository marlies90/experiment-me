# frozen_string_literal: true

class ExperimentMidwayMailJob < ActiveJob::Base
  def perform
    experiment_users = ExperimentUser.where(
      starting_date: 10.days.ago.all_day,
      status: "active"
    )

    experiment_users.map do |experiment_user|
      UserMailer.with(
        user: experiment_user.user,
        experiment: experiment_user.experiment
      ).experiment_midway_email.deliver_later
    end
  end
end
