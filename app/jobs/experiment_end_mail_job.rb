# frozen_string_literal: true

class ExperimentEndMailJob < ActiveJob::Base
  def perform
    experiment_users = ExperimentUser.where(
      ending_date: 12.hours.ago..DateTime.current,
      status: "active"
    )

    experiment_users.map do |experiment_user|
      next if experiment_user.user
      &.mail_preferences
      &.find_by(mail_type: "experiment_end")
      &.inactive?

      UserMailer.with(
        user: experiment_user.user,
        experiment: experiment_user.experiment,
        experiment_user: experiment_user
      ).experiment_end_email.deliver_later
    end
  end
end
