class Api::V1::BranchesController < ApplicationController
  before_action :authorize 

  def create 
    @branch = Branch.new(branch_params)

    if @branch.save 
      render json: @branch, status: :created 
    else 
      render json: @branch.errors, status: :unprocessable_entity
    end
  end

  private 

  def branch_params 
    params.require(:branch).permit(:company_id, :name, :fund, :notes).merge(open_at: Time.now.utc, status: true)
  end
end
