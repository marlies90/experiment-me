# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  rescue_from Net::SMTPAuthenticationError do
    redirect_back(fallback_location: home_url, alert: "Error: email could not be sent")
  end

  default from: "info@experiment.rocks"
  layout "mailer"
end
