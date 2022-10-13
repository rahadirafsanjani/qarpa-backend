class Api::V1::BranchesController < ApplicationController
  before_action :authorize 
  before_action :set_branch, only: %i[ close open ]

  def create 
    @address = Address.new(new_address)

    return render json: { message: @address.errors } if !@address.save

    @branch = Branch.new(new_branch.merge(address_id: @address.id))

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

  def new_address 
    {
      "full_address": branch_params[:full_address],
      "postal_code": branch_params[:postal_code],
    }
  end

  def new_branch
    {
      "name": branch_params[:name],
      "company_id": branch_params[:company_id],
      "open_at": Time.now.utc,
      "fund": branch_params[:fund],
      "notes": branch_params[:notes],
      "status": true
    }
  end

  def branch_params 
    params.require(:branch).permit(
      :company_id, :name, :fund, :notes, :full_address, :postal_code).merge(status: true
    )
  end
end
