# frozen_string_literal: true

module DashboardHelper
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def journal_entry_for_date(date)
    JournalEntry.includes(:journal_ratings).find_by(date: date)
  end
end
