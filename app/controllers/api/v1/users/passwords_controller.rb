class Api::V1::Users::PasswordsController < ApplicationController
  before_action :authorize, only: %i[ update ]
  before_action :email_present?, only: %i[ forgot ]
  before_action :token_present?, only: %i[ reset ]

  def forgot
    user = User.find_by(email: params[:email])
    if user.present?
      PasswordMailer.with(token: user.generate_password_token!, user: user).reset.deliver_now
      response_to_json("If an account with thath email was found, we have sent a link to reset your password", :ok)
    else
      response_to_json("Email address not found. Please check and try again", :not_found)
    end
  end

  def reset 
    token = params[:token].to_s 
    user = User.find_by(reset_password_token: token)

    if user.present? && user.password_token_valid?
      if user.reset_password!(params[:password])
        response_to_json("Password updated succressfully", :ok)
      else
        response_to_json(user.errors.full_messages, :unprocessable_entity)
      end
    else
      response_to_json("Link not valid or expired. Try generating a new link", :not_found)
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

  def email_present?
    return response_to_json("Email not present", :unprocessable_entity) if params[:email].blank?
  end
  
  def token_present?
    return response_to_json("Token not present", :unprocessable_entity) if params[:token].blank?
  end

  def response_to_json(message, status)
    render json: { message: message }, status: status
  end
end
