class BenefitsController < ApplicationController
  before_action :set_benefit, only: [:show, :edit, :update, :destroy]

  def new
    @benefit = Benefit.new
  end

  def edit
  end

  def create
    @benefit = Benefit.new(benefit_params)

    if @benefit.save
      redirect_to dashboard_admin_path, notice: 'Benefit was successfully created.'
    else
      render :new
    end
  end

  def update
    if @benefit.update(benefit_params)
      redirect_to dashboard_admin_path, notice: 'Benefit was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @benefit.destroy
    redirect_to dashboard_admin_path, notice: 'Benefit was successfully destroyed.'
  end

  private

  def set_benefit
    @benefit = Benefit.find(params[:id])
  end

  def benefit_params
    params.fetch(:benefit).permit(:name, :measurement_statement)
  end
end
