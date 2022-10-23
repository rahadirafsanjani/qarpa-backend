class Api::V1::Users::PasswordsController < ApplicationController
  before_action :authorize, only: %i[ update ]

  def forgot
    return render json: { error: 'Email not present' } if params[:email].blank?

    user = User.find_by(email: params[:email])
    if user.present?
      PasswordMailer.with(token: user.generate_password_token!, user: user).reset.deliver_now

      render json: { message: "If an account with that email was found, we have sent a link to reset your password" }
    else
      render json: { message: 'Email address not found. Please check and try again.' }, status: :not_found
    end
  end

  def reset 
    return render json: { message: 'Token not present' } if params[:token].blank?

    token = params[:token].to_s 

    user = User.find_by(reset_password_token: token)

    if user.present? && user.password_token_valid?
      if user.reset_password!(params[:password])
        render json: { message: 'password updated successfully' }, status: :ok
      else
        render json: { message: user.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { message: 'Link not valid or expired. Try generating a new link.' }, status: :not_found
    end
  end

  def update
    if @user.authenticate(params[:old_password]) && @user.update(password: params[:new_password])
      response_to_json("Password updated successfully", :ok)
    else 
      response_to_json("Invalid password", :unprocessable_entity)
    end
  end

  private 

  def response_to_json(message, status)
    render json: { message: message }, status: status
  end
end
