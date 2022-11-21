class Address < ApplicationRecord
  has_many :suppliers 
  has_many :branches
  has_many :shippings

  validates :full_address, presence: true
end
