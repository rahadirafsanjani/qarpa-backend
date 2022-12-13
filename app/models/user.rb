class User < ApplicationRecord
  has_many :attendances
  has_many :orders
  has_many :management_works
  has_many :leave_managements
  has_many :sessions
  belongs_to :company
  belongs_to :branch, optional: true
  has_one_attached :avatar

  require "securerandom"
  has_secure_password

  validates :email, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP } 
  validates :password, length: { minimum: 8 }
  validates :name, :email, :password, presence: true

  def is_owner?
    return self.role == "owner"
  end

  def self.get_all params = {}
    users = User.where("users.company_id = ? AND users.id != ?", params[:company_id], params[:id])
    users.map do |user|
      user.user_attribute
    end 
  end

  def self.get_dropdown_employee params = {}
    users = User.where("users.company_id = ? AND users.id != ?", params[:company_id], params[:id])
    users.map do |user|
      {
        "id": user.id,
        "value": user.name
      }
    end
  end

  def company_attribute 
    {
      "company": {
        "id": self.company.id,
        "name": self.company.name
      }
    } 
  end

  def branch_attribute 
    {
      "branch": {
        "id": self.branch.id,
        "name": self.branch.name
      }
    }
  end

  def user_attribute
    {
      "id": self.id,
      "avatar": self.avatar_url,
      "name": self.name,
      "email": self.email,
      "role": self.role,
      "company_id": self.company_id,
      "branch_id": self.branch_id,
      "company_name": self.company.name
    }
  end

  def generate_password_token!
    token = generate_token
    self.reset_password_token = token
    self.reset_password_sent_at = Time.now.utc
    save!(validate: false)
    return token
  end

  def password_token_valid?
    (self.reset_password_sent_at + 4.hours) > Time.now.utc
  end

  def reset_password!(password)
    self.reset_password_token = nil
    self.password = password
    save!
  end

  def generate_token
    SecureRandom.hex(10)
  end

  # regist by token
  def generate_regist_token!
    token = generate_regis_token
    self.regist_token = token
    self.regist_token_sent_at = Time.now.utc
    save!(validate: false)
    return token
  end

  def destroy_token!
    self.regist_token = nil
    save!
  end

  def token_valid?
    (self.regist_token_sent_at + 11.hours) > Time.now.utc
  end

  def generate_regis_token
    SecureRandom.base58(6)
  end

  def avatar_url
    Rails.application.routes.url_helpers.url_for(avatar) if avatar.attached?
  end

  def self.save_email params = {}
    @user = User.find_by(email: params[:email])
    return false if @user.present? && @user.confirmed_at.present?

    unless @user.present? 
      @user = User.new(params)
      @user.save!(validate: false)
    end

    RegistrationMailer.with(token: @user.generate_regist_token!, user: @user).regist.deliver_now
  end
end
