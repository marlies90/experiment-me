# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def experiment_start_email
    UserMailer.with(user: User.first, experiment: Experiment.first).experiment_start_email
  end

  def experiment_midway_email
    UserMailer.with(user: User.first, experiment: Experiment.first).experiment_midway_email
  end
end
