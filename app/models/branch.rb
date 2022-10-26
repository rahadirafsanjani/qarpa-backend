class Branch < ApplicationRecord
  attr_accessor :full_address, :postal_code
  before_validation :validate_address, :create_address
  
  belongs_to :address 
  belongs_to :company
  has_many :pos
  has_many :users 
  
  validates :name, presence: true

  private

  def validate_address 
    errors.add(:full_address, "Full address cannot be blank") if self.full_address.blank?
    errors.add(:postal_code, "Postal code cannot be blank") if self.postal_code.blank?
    raise ActiveRecord::Rollback if self.postal_code.blank? || self.full_address.blank?
  end

  def create_address
    address = Address.find_or_create_by(full_address: self.full_address, postal_code: self.postal_code)
    self.address_id = address.id
  end
end
