# frozen_string_literal: true

class Api::ProgressDataController < Api::BaseController
  def create
    respond_to do |format|
      format.js
    end
  end

  def filtered
    selected_observations = @observations.where(date: @start_date..@end_date).order(:date)

    dates = (@start_date..@end_date).to_a

    graph_data = %w[mood sleep health relax connect meaning].map do |category|
      {
        name: category.capitalize,
        data: dates.map do |date|
          observation = selected_observations.find_by(date: date.all_day)
          if observation && @categories.include?(category)
            [date.to_s(:journal_date), observation.send(category)]
          else
            [date.to_s(:journal_date), nil]
          end
        end
      }
    end

    render json: graph_data.chart_json
  end
end
