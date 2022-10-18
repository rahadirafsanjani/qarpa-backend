class Api::V1::Users::SessionsController < ApplicationController
  def login 
    @user = User.find_by(email: user_params[:email])
    
    if @user && @user.authenticate(user_params[:password])
      token = encode_token({ user_id: @user.id })
      render json: { token: token, user: @user.login_response }, status: :ok
    else
      render json: { error: "Invalid username or password" }, status: :unauthorized
    end      
  end

  private 

  def user_params
    params.require(:user).permit(:email, :password)
  end
end