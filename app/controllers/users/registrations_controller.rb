class Users::RegistrationsController < ApplicationController
  def create 
    @user = User.create(user_params)

    if @user.valid?
      token = encode_token({ user_id: @user.id })
      render json: { user: @user, token: token }, status: :created 
    else 
      render json: { error: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private 

  def user_params 
    params.require(:user).permit(:name, :email, :password).merge("role": "owner")
  end
end
