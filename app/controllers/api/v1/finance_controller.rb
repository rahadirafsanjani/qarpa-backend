class Api::V1::FinanceController < ApplicationController
  before_action :authorize

  def index 
    response_to_json("Finance", {incomes: 1000000, transaction: 50, product: 100, expenses: 500000}, :ok)
  end

  private 

  def finance_params 
    params.require(:finance).permit(:date, :branch_id).merge(company_id: @user.company_id)
  end
end
