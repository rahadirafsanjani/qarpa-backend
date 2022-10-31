class Customer < ApplicationRecord
  attr_accessor :full_address, :postal_code
  before_validation :create_address

  has_many :orders
  belongs_to :address
  belongs_to :company
  
  validate :validate_address
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, :phone, :email, presence: true
  validates :phone, numericality: { only_integer: true }

  private 

  def validate_address 
    errors.add(:full_address, "full address cannot be blank") if self.full_address.blank?
    errors.add(:postal_code, "postal code cannot be blank") if self.postal_code.blank?
  end

  def create_address
    address = Address.find_or_create_by(full_address: self.full_address, postal_code: self.postal_code)
    self.address_id = address.id
  end
end
