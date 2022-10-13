class Api::V1::BranchesController < ApplicationController
  before_action :authorize 
  before_action :set_branch, only: %i[ close open ]

  def create 
    @branch = Branch.new(branch_params.merge(open_at: Time.now.utc))

    if @branch.save 
      render json: @branch, status: :created 
    else 
      render json: @branch.errors, status: :unprocessable_entity
    end
  end

  def close 
    if @branch.close_branch()
      render json: { message: "The branch has been closed" }, status: :ok
    else
      render json: { message: "The branch is already closed" }, status: :unprocessable_entity
    end
  end

  def open 
    if @branch.open_branch()
      render json: { message: "The branch has been opened" }, status: :ok 
    else 
      render json: { message: "The branch is already opened" }, status: :unprocessable_entity
    end
  end

  private 

  def set_branch
    begin
      @branch = Branch.find(params[:id])
    rescue => exception
      render json: { message: "Branch not found" }, status: :not_found
    end
  end

  def branch_params 
    params.require(:branch).permit(:company_id, :name, :fund, :notes).merge(status: true)
  end
end
