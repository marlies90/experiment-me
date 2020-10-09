# frozen_string_literal: true

class Api::ProgressDataController < Api::BaseController
  def create
    respond_to do |format|
      format.js
    end
  end

  def filtered
    selected_journal_entries = @journal_entries.where(date: @start_date..@end_date).order(:date)

    dates = (@start_date..@end_date).to_a

    graph_data = %w[mood sleep health relax connect meaning].map do |category|
      {
        name: category.capitalize,
        data: dates.map do |date|
          journal_entry = selected_journal_entries.find_by(date: date.all_day)
          if journal_entry && @categories.include?(category)
            [date.to_s(:journal_date), journal_entry.send(category)]
          else
            [date.to_s(:journal_date), nil]
          end
        end
      }
    end

    render json: graph_data.chart_json
  end
end
