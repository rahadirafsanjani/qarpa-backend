class Api::V1::LeaveManagementsController < ApplicationController
  before_action :authorize

  def create 
    
  end

  private 

  def leave_management_params  
    params.require(:management_work).permit(:title, :notes, :leave_status, :start_at, :end_at).merge(user_id: @user.id)    
  end
end
