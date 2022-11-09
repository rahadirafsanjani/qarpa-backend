class Customer < ApplicationRecord
  attr_accessor :full_address
  before_validation :create_address

  has_many :shippings
  has_many :orders
  belongs_to :address
  belongs_to :company
  
  validate :validate_address
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, :phone, :email, presence: true
  validates :phone, numericality: { only_integer: true }

  def self.customer_response params = {}
    customers = Customer.includes(:address).where(params)
    customers.map do |customer|
      customer.new_response 
    end
  end

  def new_response 
    {
      "id": self.id,
      "name": self.name, 
      "phone": self.phone,
      "address": self.address.full_address,
      "email": self.email 
    }
  end

  private 

  def validate_address 
    errors.add(:full_address, "full address cannot be blank") if self.full_address.blank?
  end

  def create_address
    address = Address.find_or_create_by(full_address: self.full_address)
    self.address_id = address.id
  end
end
