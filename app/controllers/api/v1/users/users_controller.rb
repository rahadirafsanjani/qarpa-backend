class Api::V1::Users::UsersController < ApplicationController
  before_action :authorize
  before_action :set_user, only: %i[ show update destroy ]

  def create 
    @user = User.new(user_params.merge(role: 'employee', confirmed_at: Time.now.utc))

    if @user.save 
      response_to_json(@user, :created)
    else
      response_error(@user.errors, :unprocessable_entity)
    end
  end

  def show 
    response_to_json(@user, :ok)
  end

  def update 
    if @user.update(user_params)
      response_to_json(@user, :ok)
    else
      response_error(@user.errors, :unprocessable_entity)
    end
  end

  def destroy 
    @user.destroy

    response_to_json(@user, :ok)
  end

  private 

  def response_to_json(message, status)
    render json: message, status: status
  end

  def response_error(message, status)
    render json: { message: message }, status: status
  end

  def set_user 
    begin
      @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound 
      response_error("User not found", :not_found) 
    end
  end

  def user_params 
    params.require(:user).permit(:name, :email, :password).merge(company_id: @user.company_id)
  end
end
