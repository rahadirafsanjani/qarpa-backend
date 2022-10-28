class Api::V1::ManagementWorksController < ApplicationController
  before_action :authorize 
  before_action :set_management_works, only: %i[ done update ]

  def index 
    @works = ManagementWork.task_response(company_id: @user.company_id)
    render json: @works, status: :ok
  end

  def get_for_employee
    @works = ManagementWork.task_response(user_id: @user.id)
    render json: @works, status: :ok
  end

  def create
    @work = ManagementWork.new(management_work_params)
    @work.save ? response_to_json("Task created successfully", @work, :created) :
                 response_error(@work.errors, :unprocessable_entity)
  end

  def show 
    @work = ManagementWork.show_task(id: params[:id])
    @work ? response_to_json("Task found", @work, :ok) :
            response_error("Task not found", :not_found)
  end

  def update 
    @work.update(management_work_params) ? response_to_json("Task updated successfully", @work, :ok) :
                                           response_error(@work.errors, :unprocessable_entity)
  end

  def done 
    @work.done! ? response_to_json("Task updated successfully", @work, :ok) : 
                  response_error("Something went wrong", :unprocessable_entity)
  end

  private 

  def set_management_works
    @work = ManagementWork.find_by(id: params[:id])
    response_error("Task not found", :not_found) unless @work.present?
  end

  def response_to_json(message, data, status)
    render json: { message: message, data: data }, status: status
  end

  def response_error(message, status)
    render json: { message: message }, status: status
  end

  def management_work_params 
    params.require(:management_work).permit(:task, :description, :start_at, :end_at, :user_id).merge(company_id: @user.company_id)
  end
end
