class User < ApplicationRecord
  belongs_to :company

  require "securerandom"
  has_secure_password

  validates :email, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP } 
  validates :password, length: { minimum: 6 }
  validates :name, :email, :password, presence: true

  def login_response 
    {
      "id": self.id,
      "name": self.name,
      "email": self.email,
      "role": self.role
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
end