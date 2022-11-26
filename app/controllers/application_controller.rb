class ApplicationController < ActionController::API
  ACCESS_SECRET_KEY = Rails.application.credentials.jwt.access_secret

  def encode_token(payload, secret)
    JWT.encode(payload, secret)
  end

  def decode_token(token_params = "", secret)
    if token_params 
      token = token_params.split(' ')[1]
      begin
        JWT.decode(token, secret)
      rescue JWT::DecodeError
        nil
      end
    end
  end

  def get_id_from_refresh_token(token = "", secret)
    user_id = nil
    
    begin
      decoded_token = JWT.decode(token, secret)
    rescue JWT::DecodeError
      nil
    end
    
    user_id = decoded_token[0]["user_id"] if decoded_token

    return user_id
  end

  def authorized_user 
    auth_header = request.headers['Authorization']

    decoded_token = decode_token(auth_header, ACCESS_SECRET_KEY)
    if decoded_token 
      user_id = decoded_token[0]["user_id"]
      @user = User.find_by(id: user_id)
    end
  end

  def authorize 
    render json: { message: 'You have to log in.' }, status: :unauthorized unless authorized_user
  end

  def response_to_json(message, data, status)
    render json: { message: message, data: data }, status: status
  end

  def response_error(message, status)
    render json: { message: message }, status: status
  end

  def user_permission 
    response_error("you don't have permission to access this resource", :forbidden) unless @user.is_owner?
  end
end
