# frozen_string_literal: true

class PagesController < ApplicationController
  def home; end

  def privacy_statement
    begin
      1 / 0
    rescue ZeroDivisionError => exception
      Sentry.capture_exception(exception)
    end

    Sentry.capture_message("test message")
  end

  def terms_conditions; end

  def contact; end
end
