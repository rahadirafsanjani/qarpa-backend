class Api::V1::ManagementWorksController < ApplicationController
  before_action :authorize 
  before_action :set_management_works, only: %i[ done update show ]

  def index 
    @works = ManagementWork.task_response(company_id: @user.company_id)
    response_to_json("List task", @works, :ok)
  end

  def get_for_employee
    @works = ManagementWork.task_response(user_id: @user.id)
    response_to_json("List task", @works, :ok)
  end

  def create
    @work = ManagementWork.new(management_work_params)
    @work.save ? response_to_json("Task created successfully", @work.new_response, :created) :
                 response_error(@work.errors, :unprocessable_entity)
  end

  def show 
    @work ? response_to_json("Task found", @work.new_response, :ok) :
            response_error("Task not found", :not_found)
  end

  def update 
    @work.update(management_work_params) ? response_to_json("Task updated successfully", @work.new_response, :ok) :
                                           response_error(@work.errors, :unprocessable_entity)
  end

  def done 
    @work.done! ? response_to_json("Task updated successfully", @work.new_response, :ok) : 
                  response_error("Something went wrong", :unprocessable_entity)
  end

  private 

  def set_management_works
    @work = ManagementWork.find_by(id: params[:id])
    response_error("Task not found", :not_found) unless @work.present?
  end

  def management_work_params 
    params.require(:management_work).permit(:task, :description, :start_at, :end_at, :user_id).merge(company_id: @user.company_id)
  end
end
