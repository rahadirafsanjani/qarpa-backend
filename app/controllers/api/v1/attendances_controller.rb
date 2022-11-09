class Api::V1::AttendancesController < ApplicationController
  before_action :authorize
  before_action :pick_users, only: %i[ update ]

  def all_history
    @attendances = Attendance.get_all_attendace(user: { company_id: @user.company_id})
    response_to_json("success", @attendances, :ok)
  end

  def create
    @attendance = Attendance.new(set_attendance.merge(user_id: @user.id))
    if @attendance.save && @attendance.status == false
      @attendance.update(status: true)
      render json: @attendance
    else
      render json: { message: "there was problem" }
    end
  end

  def update
    if @attendance.update(set_attendance)
       @attendance.update(status: nil)
       render json: @attendance
    else
      render json: { message: "there was problem" }
    end
  end

  private
  def pick_users
    @attendance = Attendance.find_by(user_id: @user.id, status: true)
  end
  def set_attendance
    params.require(:attendance).permit(:id, :check_in, :check_out, :latitude, :longitude)
  end
end