class Api::V1::BranchesController < ApplicationController
  before_action :authorize 
  before_action :set_branch, only: %i[ close open ]

  def create 
    @branch = Branch.new(branch_params)
    
    @branch.save ? response_to_json(@branch, :created) : 
                   response_error( @branch.errors, :unprocessable_entity)
  end

  private 

  def set_branch
    @branch = Branch.find_by(id: params[:id])
    response_to_json("Branch not found", :not_found) if @branch.blank?
  end

  def response_to_json(message, status) 
    render json: message, status: status
  end

  def response_error(message, status) 
    render json: { message: message }, status: status
  end

  def branch_params 
    params.require(:branch).permit(:name, :full_address, :postal_code).merge(company_id: @user.company_id)
  end
end
