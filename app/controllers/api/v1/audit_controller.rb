class Api::V1::AuditController < ApplicationController
  before_action :authorize 
  
  def sum_expenses_incomes 
    @sum = Audit.expenses_incomes(company_id: @user.company_id)
    response_to_json("Incomes and expenses", @sum, :ok)
  end

  def get_branch
    @audits = Audit.filter_by(date: params[:date], branch_id: params[:branch_id], company_id: @user.company_id)

    @audits ? response_to_json("List branch", @audits, :ok) : 
              response_error("Branch id cannot be blank", :bad_request)
  end
end
