# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: "Experiment.rocks <info@experiment.rocks>"
  layout "mailer"
end
