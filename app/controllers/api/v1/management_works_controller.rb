class Api::V1::ManagementWorksController < ApplicationController
  before_action :authorize 
  before_action :set_management_works, only: %i[ done ]

  def create
    @work = ManagementWork.new(management_work_params)
    @work.save ? response_to_json("Task created successfully", @work, :created) :
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
    params.require(:management_work).permit(:task, :description, :start_at, :end_at, :user_id)  
  end
end
