class RegistrationMailer < ApplicationMailer

  def regist
    @token = params[:token]
    mail to: params[:user].email
  end
end