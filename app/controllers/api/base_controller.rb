# frozen_string_literal: true

class Api::BaseController < ApplicationController
  before_action :load_data
  before_action :set_categories
  before_action :format_dates

  private

  def load_data
    @journal_entries = JournalEntry.per_user(current_user).select(
      :date, :mood, :sleep, :health, :relax, :connect, :meaning
    )
  end

  def set_categories
    @categories = params[:categories] || %w[mood sleep health relax connect meaning]
  end

  def format_dates
    @start_date = params[:start_date].to_datetime.at_end_of_day
    @end_date = params[:end_date].to_datetime.at_end_of_day
  end
end
