class ExpensesController < ApplicationController
  before_filter :find_vehicle

  def create
    @expense = @vehicle.expenses.new(expense_params)
    if @expense.save
      redirect_to vehicle_path(@vehicle), notice: "Expense saved!"
    else
      redirect_to :back, alert: @expense.errors.full_messages
    end
  end

  protected

  def expense_params
    params.require(:expense).permit(:amount_cents, :category, :date)
  end

  def find_vehicle
    @vehicle = Vehicle.find(params[:vehicle_id])
  end

end
