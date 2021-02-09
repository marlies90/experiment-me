# frozen_string_literal: true

class SendGoogleAnalyticsEventJob < ActiveJob::Base
  queue_as :default

  def perform(event_params)
    Faraday.post(GOOGLE_ANALYTICS_SETTINGS[:endpoint], event_params)
    true
  rescue Faraday::Error
    false
  end
end
