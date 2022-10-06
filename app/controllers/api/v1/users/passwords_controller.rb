class Api::V1::Users::PasswordsController < ApplicationController
  def forgot 
    return render json: { error: 'Email not present' } if params[:email].blank?

    user = User.find_by(email:  params[:email])
    if user.present?
      PasswordMailer.with(token: user.generate_password_token!, user: user).reset.deliver_now
    else 
      render json: { error: ['Email address not found. Please check and try again.'] }, status: :not_found
    end
  end

  def reset 
    return render json: { error: 'Token not present' } if params[:token].blank?
    
    token = params[:token].to_s 

    user = User.find_by(reset_password_token: token)

    if user.present? && user.password_token_valid?
      if user.reset_password!(params[:password])
        render json: { status: 'ok' }, status: :ok
      else
        render json: { error: user.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: ['Link not valid or expired. Try generating a new link.'] }, status: :not_found
    end
  end
end
