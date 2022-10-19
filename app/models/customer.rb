class Customer < ApplicationRecord
  attr_accessor :full_address, :postal_code
  before_validation :create_address

  has_many :orders
  belongs_to :address
  
  validates :name, :phone, presence: true
  validates :phone, numericality: { only_integer: true }

  def create_address
    address = Address.find_or_create_by(full_address: self.full_address, postal_code: self.postal_code)
    self.address_id = address.id
  end
end
