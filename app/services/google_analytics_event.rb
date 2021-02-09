# frozen_string_literal: true

class GoogleAnalyticsEvent
  def initialize(category, action, label, client_id)
    @category = category
    @action = action
    @label = label
    @client_id = client_id.present? ? client_id : "555"
  end

  def event
    return unless GOOGLE_ANALYTICS_SETTINGS[:tracking_code].present?

    SendGoogleAnalyticsEventJob.perform_later(event_params)
  end

  private

  def event_params
    {
      v: GOOGLE_ANALYTICS_SETTINGS[:version],
      tid: GOOGLE_ANALYTICS_SETTINGS[:tracking_code],
      cid: @client_id,
      t: "event",
      ec: @category,
      ea: @action,
      el: @label
    }
  end
end
