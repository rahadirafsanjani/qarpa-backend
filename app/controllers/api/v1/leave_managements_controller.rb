class Api::V1::LeaveManagementsController < ApplicationController
  before_action :authorize
  before_action :set_leave_managements, only: %i[ action ]

  def index 
    @leaves = LeaveManagement.leave_response(user: { company_id: @user.company_id })
    response_to_json("List time off", @leaves, :ok)
  end

  def get_for_employee
    @leaves = LeaveManagement.leave_response_employee(@user.id)
    response_to_json("List time off", @leaves, :ok)
  end

  def create 
    @leave = LeaveManagement.new(leave_management_params)
    @leave.save ? response_to_json("Leave created successfully", @leave.new_response, :created) : 
                  response_error(@leave.errors, :unprocessable_entity)
  end

  def action 
    @leave.action(params[:status]) ? response_to_json("Leave updated successfully", @leave.new_response, :ok) :
                                     response_error("Something went wrong", :unprocessable_entity)
  end

  private 

  def set_leave_managements 
    @leave = LeaveManagement.find_by(id: params[:id])
    response_error("Leave not found", :not_found) unless @leave.present?
  end

  def leave_management_params  
    params.require(:leave_management).permit(:title, :notes, :start_at, :end_at).merge(user_id: @user.id)    
  end
end
