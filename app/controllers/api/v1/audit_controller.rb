class Api::V1::AuditController < ApplicationController
  before_action :authorize 
  
  def sum_expenses_incomes 
    @sum = Audit.expenses_incomes(company_id: @user.company_id)
    response_to_json("Incomes and expenses", @sum, :ok)
    # response_to_json("Incomes and expenses", { incomes: 1000000, expenses: 500000 }, :ok)
  end

  def reports 
    @reports = Audit.get_reports(company_id: @user.company_id, date: params[:date])
    
    response = {}
    response.merge!(messages: "Report list")
    response.merge!(@reports)

    render json: response, status: :ok
  end
end
