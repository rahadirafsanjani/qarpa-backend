class Api::V1::FinanceController < ApplicationController
  before_action :authorize

  def index 
    @reports = nil
    
    if @user.branch_id.present? && params[:branch_id].nil?
      @reports = Finance.get_report(params.merge(branch_id: @user.branch_id, company_id: @user.company_id))
    else
      @reports = Finance.get_report(params.merge(company_id: @user.company_id))
    end

    response_to_json("Finance", @reports, :ok)
  end
end