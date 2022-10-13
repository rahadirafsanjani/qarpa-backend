class ApplicationController < ActionController::API
  # SECRET_KEY = Rails.application.credentials.jwt.secret
  def encode_token(payload)
    payload[:exp] = Time.now.to_i + 1 * 3600
    JWT.encode(payload, SECRET_KEY)
  end

  def decode_token
    auth_header = request.headers['Authorization']

    if auth_header 
      token = auth_header.split(' ')[1]
      begin
        JWT.decode(token, SECRET_KEY)
      rescue JWT::DecodeError
        nil
      end    
    end
  end

  def authorized_user 
    decoded_token = decode_token()
    if decoded_token 
      user_id = decoded_token[0]['user_id']
      @user = User.find_by(id: user_id)
    end
  end

  def authorize 
    render json: { message: 'You have to log in.' }, status: :unauthorized unless authorized_user
  end
end
