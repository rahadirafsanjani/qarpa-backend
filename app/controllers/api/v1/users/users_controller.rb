class Api::V1::Users::UsersController < ApplicationController
  before_action :authorize
  before_action :set_user, only: %i[ show update destroy ]

  def create 
    @user = User.new(user_params.merge(role: 'employee', confirmed_at: Time.now.utc))
    AvatarGenerator.call(@user)
    @user.save ? response_to_json("New user has been created", @user.user_attribute, :created) : response_error(@user.errors, :unprocessable_entity)
  end

  def show 
    response_to_json("User found", @user.user_attribute, :ok)
  end

  def update 
    @user.update(user_params) ? response_to_json("User has been updated", :ok) : response_error(@user.errors, :unprocessable_entity)
  end

  def destroy 
    @user.destroy

    response_to_json("User has been deleted", @user.user_attribute, :ok)
  end

  private 

  def set_user 
    @user = User.find_by(id: params[:id])
    response_error("User not found", :not_found) unless @user.present?
  end

  def user_params 
    params.require(:user).permit(:name, :email, :password).merge(company_id: @user.company_id)
  end
end
