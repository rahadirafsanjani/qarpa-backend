class User < ApplicationRecord
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
end
