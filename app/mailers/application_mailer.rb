# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: "info@experiment-rocks.com"
  layout "mailer"
end
