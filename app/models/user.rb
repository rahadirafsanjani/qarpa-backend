class User < ApplicationRecord
  require "securerandom"

  has_secure_password 

  validates :email, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP } 
  validates :password, length: { minimum: 6 }
  validates :name, :email, :password, presence: true
end
