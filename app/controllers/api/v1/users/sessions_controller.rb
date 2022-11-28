class Api::V1::Users::SessionsController < ApplicationController
  ACCESS_SECRET_KEY = Rails.application.credentials.jwt.access_secret
  REFRESH_SECRET_KEY = Rails.application.credentials.jwt.refresh_secret

  def login 
    @user = User.find_by(email: user_params[:email])
    
    if @user && @user.authenticate(user_params[:password])
      token_payload = { user_id: @user.id }
      access_token = encode_token(token_payload.merge(exp: Time.now.to_i + 30 * 60), ACCESS_SECRET_KEY)
      refresh_token = encode_token(token_payload.merge(exp: Time.now.to_i + 24 * 60 * 60), REFRESH_SECRET_KEY)

      render json: { 
        access_token: access_token,
        refresh_token: refresh_token,
        user: @user.user_attribute 
      }, status: :ok
    else
      render json: { error: "Invalid username or password" }, status: :unauthorized
    end      
  end

  def refresh_token 
    user_id = get_id_from_refresh_token(params[:refresh_token], REFRESH_SECRET_KEY)

    if user_id 
      token_payload = { user_id: user_id }
      access_token = encode_token(token_payload.merge(exp: Time.now.to_i + 30 * 60), ACCESS_SECRET_KEY)
      refresh_token = encode_token(token_payload.merge(exp: Time.now.to_i + 24 * 60 * 60), REFRESH_SECRET_KEY)

      render json: { access_token: access_token, refresh_token: refresh_token }, status: :ok
    else 
      response_error("Invalid token", :bad_request)
    end
  end

  private 

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
