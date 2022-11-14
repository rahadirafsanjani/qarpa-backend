class Api::V1::FinanceController < ApplicationController
  before_action :authorize

  def index 
    @reports = nil
    
    if @user.branch_id.present? && finance_params[:branch_id].nil?
      @reports = Finance.get_report(finance_params.merge(branch_id: @user.branch_id))
    else
      @reports = Finance.get_report(finance_params)
    end

    response_to_json("Finance", @reports, :ok)
  end

  private 

  def finance_params 
    params.require(:finance).permit(:date, :branch_id).merge(company_id: @user.company_id)
  end
end
