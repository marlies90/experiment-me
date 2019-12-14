class JournalEntriesController < ApplicationController
  before_action :set_user
  before_action :set_journal_entry, only: [:show, :edit, :update, :destroy]


  def index
  end

  def show
  end

  def new
    @journal_entry = JournalEntry.new
    journal_ratings = JournalStatement.all.map do |statement|
      JournalRating.new(journal_statement: statement)
    end

    @journal_entry.journal_ratings = journal_ratings

    @dates = []
    14.times do |index|
      @dates << DateTime.current.beginning_of_day - index
    end
  end

  def edit

  end

  def create
    @journal_entry = JournalEntry.new(journal_entry_params)
    @journal_entry.user_id = current_user.id

    if @journal_entry.save
      redirect_to dashboard_journal_path, notice: 'Journal entry was successfully created.'
    else
      render :new
    end
  end

  def update
    @journal_entry.user_id = current_user.id

    if @journal_entry.update(journal_entry_params)
      redirect_to dashboard_journal_path, notice: 'Journal entry was successfully updated.'
    else
      render :edit
    end
  end

  private

  def set_user
    @user = current_user
    authorize self
  end

  def set_journal_entry
    @journal_entry = JournalEntry.find(params[:id])
  end

  def journal_entry_params
    params.fetch(:journal_entry).permit(
      :date, :user_id,
      journal_ratings_attributes: [:id, :journal_statement_id, :score]
    )
  end
end
