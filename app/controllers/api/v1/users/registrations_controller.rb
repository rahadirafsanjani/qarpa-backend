class Api::V1::Users::RegistrationsController < ApplicationController
  # token 6 digit into mail
  def token_registration
    return render json: { error: 'Email not present' } if params[:email].blank?
    user = User.new(email: params[:email])
    if user.save(validate: false)
      RegistrationMailer.with(token: user.generate_regist_token!, user: user).regist.deliver_now
      render json: { message: "If an account with that email was found, we have sent" }
    else
      render json: { error: 'Email address not found. Please check and try again.' }, status: :not_found
    end
  end

  def token_redeem
    return render json: { error: 'Token not present' } if params[:token].blank?
    token = params[:token].to_s
    @user = User.find_by(regist_token: params[:token])
    if @user.present? && @user.token_valid? { render json: { message: "token was expire" }, status: :unprocessable_entity }
      render json: { message: "token was found and secured", token: token }, status: :ok
    else
      render json: { message: "please input valid token" }, status: :unprocessable_entity
    end
  end

  def registration
      @company = Company.new(name: params[:company_name])
      @company.save!

      @user = User.find_by(regist_token: params[:token])
      if @user.update(name: params[:name], password: params[:password], company_id: @company.id, role: "owner") && @user.token_valid?
        render json: { message: "registration successfully" }, status: :ok
        @user.destroy_token!
      else
        render json: @user.errors, status: :unprocessable_entity
      end
  end

end
