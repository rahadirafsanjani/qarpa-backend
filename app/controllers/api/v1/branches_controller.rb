class Api::V1::BranchesController < ApplicationController
  before_action :authorize 
  before_action :user_permission, only: %i[ index create ]

  def index 
    @branches = Branch.get_all_branch(company_id: @user.company_id)
    response_to_json("List branch", @branches, :ok)
  end

  def get_for_employee
    @branch = Branch.get_all_branch(id: @user.branch_id)
    response_to_json("List branch for employee", @branch, :ok) 
  end

  def show
    @branch = Branch.find_by(id: params[:id])
    @branch.present? ? response_to_json("Branch found", @branch.new_response, :ok) :
                     response_error("Branch not found", :not_found)
  end

  def create 
    @branch = Branch.new(branch_params)
    
    @branch.save ? response_to_json("New branch created", @branch.new_response, :created) : 
                   response_error( @branch.errors, :unprocessable_entity)
  end

  private 

  def branch_params 
    params.require(:branch).permit(:name, :full_address, :phone).merge(company_id: @user.company_id, status: false)
  end
end
