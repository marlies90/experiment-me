# frozen_string_literal: true

module ApplicationHelper
  def to_journal_date(date)
    date.strftime("%e %b %C%y (%a)")
  end

  def to_journal_date_no_year(date)
    date.strftime("%e %b (%a)")
  end
end
