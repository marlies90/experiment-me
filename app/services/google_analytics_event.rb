# frozen_string_literal: true

class GoogleAnalyticsEvent
  def initialize(category, action, label, client_id)
    @category = category
    @action = action
    @label = label
    @client_id = client_id.present? ? client_id : "555"
  end

  def event
    # return unless GOOGLE_ANALYTICS_SETTINGS[:tracking_code].present?

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
      response = Faraday.post(
        'https://www.google-analytics.com/debug/collect?tid=fake&v=1',
        params: params,
        timeout: 4,
        open_timeout: 4
      )
      puts "this is the response body: #{response.body}"
      true
    rescue Faraday::Error
      false
    end
  end
end
