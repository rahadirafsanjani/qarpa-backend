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
end
