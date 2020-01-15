class JournalStatementsController < ApplicationController
  before_action :set_user
  before_action :set_journal_statement, only: [:edit, :update, :destroy]

  def new
    @journal_statement = JournalStatement.new
  end

  def edit
  end

  def create
    @journal_statement = JournalStatement.new(journal_statement_params)

    if @journal_statement.save
      redirect_to dashboard_admin_path, notice: 'JournalStatement was successfully created.'
    else
      render :new
    end
  end

  def update
    if @journal_statement.update(journal_statement_params)
      redirect_to dashboard_admin_path, notice: 'JournalStatement was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @journal_statement.destroy
    redirect_to dashboard_admin_path, notice: 'JournalStatement was successfully destroyed.'
  end

  private

    def set_user
      @user = current_user
      authorize self
    end

    def set_journal_statement
      @journal_statement = JournalStatement.find(params[:id])

    end

    def journal_statement_params
      params.fetch(:journal_statement).permit(:name)
    end
end
