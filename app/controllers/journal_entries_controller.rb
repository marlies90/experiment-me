class JournalEntriesController < ApplicationController
  before_action :set_user
  before_action :set_journal_entry, only: [:show, :edit, :update, :destroy]

  def index
     @journal_entries = JournalEntry.per_user(current_user)
  end

  def show
  end

  def new
    @journal_entry = JournalEntry.new
    journal_ratings = JournalStatement.all.map do |statement|
      JournalRating.new(journal_statement: statement)
    end
    @journal_entry.journal_ratings = journal_ratings

    create_date_list

    @entry_dates = @user.journal_entries.limit(14).map(&:date).difference(@dates).map(&:to_datetime)
    @available_dates = (@dates - @entry_dates) | (@entry_dates - @dates)
  end

  def edit

  end

  def create
    @journal_entry = JournalEntry.new(journal_entry_params)
    @journal_entry.user_id = current_user.id

    create_date_list

    if @journal_entry.save
      redirect_to journal_entries_path, notice: 'Journal entry was successfully created.'
    else
      render :new
    end
  end

  def update
    @journal_entry.user_id = current_user.id

    if @journal_entry.update(journal_entry_params)
      redirect_to journal_entries_path, notice: 'Journal entry was successfully updated.'
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

  def set_user
    @user = current_user
    authorize self
  end

  def set_journal_entry
    @journal_entry = JournalEntry.per_user(current_user).find_by(slug: params[:id])
  end

  def journal_entry_params
    params.fetch(:journal_entry).permit(
      :date, :user_id,
      journal_ratings_attributes: [:id, :journal_statement_id, :score]
    )
  end
end
