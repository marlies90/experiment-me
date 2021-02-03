# frozen_string_literal: true

class GoogleAnalyticsEvent
  def initialize(category, action, label, client_id = "555")
    @category = category
    @action = action
    @label = label
    @client_id = client_id
  end

  def event
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

    begin
      Faraday.post(
        GOOGLE_ANALYTICS_SETTINGS[:endpoint],
        params: params,
        timeout: 4,
        open_timeout: 4
      )
      true
    rescue Faraday::Exception
      false
    end
  end
end
