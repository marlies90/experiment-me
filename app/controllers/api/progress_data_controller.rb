# frozen_string_literal: true

class Api::ProgressDataController < Api::BaseController
  def create
    respond_to do |format|
      format.js
    end
  end

  def filtered
    graph_data = %w[mood sleep health relax connect meaning].map do |category|
      {
        name: category.capitalize,
        data: build_graph_data(category)
      }
    end

    render json: graph_data.chart_json
  end

  private

  def build_graph_data(category)
    selected_observations = @observations.where(date: @start_date..@end_date).order(:date)
    dates = (@start_date..@end_date).to_a

    dates.map do |date|
      observation_on_date = selected_observations.detect do |observation|
        observation.date.between?(date.beginning_of_day, date.end_of_day)
      end

      if observation_on_date && @categories.include?(category)
        [date.to_s(:journal_date), observation_on_date.send(category)]
      else
        [date.to_s(:journal_date), nil]
      end
    end
  end
end
