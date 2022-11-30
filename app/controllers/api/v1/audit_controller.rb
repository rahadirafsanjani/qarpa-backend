class Api::V1::AuditController < ApplicationController
  before_action :authorize 
  
  def sum_expenses_incomes 
    @sum = Audit.expenses_incomes(company_id: @user.company_id)
    response_to_json("Incomes and expenses", @sum, :ok)
  end

  def reports 
    @reports = Audit.get_reports(company_id: @user.company_id, date: params[:date])

    response_to_json("Reports list", @reports, :ok)
  end
end
