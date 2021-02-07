# frozen_string_literal: true

class GoogleAnalyticsEvent
  def initialize(category, action, label, client_id = "555")
    @category = category
    @action = action
    @label = label
    @client_id = client_id
  end

  def event
    puts "the event is startingggg"
    return unless GOOGLE_ANALYTICS_SETTINGS[:tracking_code].present?

    params = {
      v: GOOGLE_ANALYTICS_SETTINGS[:version],
      tid: GOOGLE_ANALYTICS_SETTINGS[:tracking_code],
      cid: @client_id,
      t: "event",
      ec: @category,
      ea: @action,
      el: @label
    }

    puts "these are the params: #{params}"
    puts "this is the endpoint: #{GOOGLE_ANALYTICS_SETTINGS[:endpoint]}"

    begin
      Faraday.post(
        GOOGLE_ANALYTICS_SETTINGS[:endpoint],
        params: params,
        timeout: 4,
        open_timeout: 4
      )
      true
    rescue Faraday::Error
      false
    end
  end
end