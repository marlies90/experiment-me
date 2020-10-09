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
    format_start_date
    format_end_date
    @start_date, @end_date = @end_date, @start_date if @end_date < @start_date
  end

  def format_start_date
    @start_date =
      if params[:start_date].nil? || params[:start_date].empty?
        21.days.ago.midnight
      else
        params[:start_date].to_datetime.midnight
      end
  end

  def format_end_date
    @end_date =
      if params[:end_date].nil? || params[:end_date].empty?
        Time.current.at_end_of_day
      else
        params[:end_date].to_datetime.at_end_of_day
      end
  end
end
