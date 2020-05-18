# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: "info@experiment.rocks"
  layout "mailer"
end
