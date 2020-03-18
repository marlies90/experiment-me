# frozen_string_literal: true

class JournalEntriesController < ApplicationController
  before_action :set_user
  before_action :set_journal_entry, only: %i[show edit update destroy]
  helper_method :date

  def index
    @journal_entries = JournalEntry.per_user(current_user)
    create_date_list
    journal_entry_dates
    @available_dates = (@dates - @journal_entry_dates) | (@journal_entry_dates - @dates)

    @active_experiment = Experiment.find_by_id(@user.experiment_users&.active&.first&.experiment_id)
  end

  def show; end

  def new
    @journal_entry = JournalEntry.new
    journal_ratings = JournalStatement.all.map do |statement|
      JournalRating.new(journal_statement: statement)
    end
    @journal_entry.journal_ratings = journal_ratings
  end

  def edit; end

  def create
    @journal_entry = JournalEntry.new(journal_entry_params)
    @journal_entry.user_id = current_user.id

    create_date_list

    if @journal_entry.save
      redirect_to journal_entries_path, notice: "Journal entry was successfully created."
    else
      render :new
    end
  end

  def update
    @date = params[:journal_entry][:date].to_datetime
    @journal_entry.user_id = current_user.id

    if @journal_entry.update(journal_entry_params)
      redirect_to journal_entries_path, notice: "Journal entry was successfully updated."
    else
      render :edit
    end
  end

  private

  def create_date_list
    @dates = []
    14.times do |index|
      @dates << DateTime.current.beginning_of_day - index
    end
  end

  def journal_entry_dates
    @journal_entry_dates =
      @user.journal_entries.newest.limit(14).map(&:date).difference(@dates).map(&:to_datetime)
  end

  def set_user
    @user = current_user
    authorize self
  end

  def set_journal_entry
    @journal_entry = JournalEntry.per_user(current_user).find_by(slug: params[:id])
  end

  def date
    if @journal_entry.date.present?
      @journal_entry.date
    elsif params[:date].present?
      params[:date].to_datetime
    else
      params[:journal_entry][:date].to_datetime
    end
  end

  def journal_entry_params
    params.fetch(:journal_entry).permit(
      :date, :user_id, :experiment_id, :experiment_success,
      journal_ratings_attributes: %i[id journal_statement_id score]
    )
  end
end
