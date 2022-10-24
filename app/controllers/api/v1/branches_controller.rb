class Api::V1::BranchesController < ApplicationController
  before_action :authorize 
  before_action :set_branch, only: %i[ close open ]

  def create 
    @branch = Branch.new(branch_params)
    
    if @branch.save
      render json: @branch, status: :created
    else 
      render json: @branch.errors, status: :unprocessable_entity
    end
  end

  def close 
    if @branch.close_branch
      response_to_json("The branch has been closed", :ok)
    else
      response_to_json("The branch is already closed", :ok)
    end
  end

  def open 
    if @branch.open_branch
      render json: { message: "The branch has been opened", data: @branch }, status: :ok
    else
      response_to_json("The branch is already opened", :ok) 
    end
  end

  private 

  def set_branch
    @branch = Branch.find_by(id: params[:id])
    response_to_json("Branch not found", :not_found) if @branch.blank?
  end

  def response_to_json(message, status) 
    render json: { message: message }, status: status
  end

  def branch_params 
    params.require(:branch).permit(:company_id, :name, :fund, :notes, :full_address, :postal_code).merge(status: true)
  end
end
