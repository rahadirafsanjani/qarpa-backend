class Api::V1::AuditController < ApplicationController
  before_action :authorize 
  
  def get_branch
    @audits = Audit.filter_by(audit_params)

    @audits ? response_to_json("List branch", @audits, :ok) : 
              response_error("Branch id cannot be blank", :bad_request)
  end

  private 

  def audit_params 
    params.require(:audit).permit(:date, :branch_id).merge(company_id: @user.company_id)
  end
end
