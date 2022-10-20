class Branch < ApplicationRecord
  attr_accessor :full_address, :postal_code
  before_validation :create_address
  
  belongs_to :address 
  belongs_to :company
  has_many :users 
  has_many :orders
  
  validates :name, :fund, :notes, presence: true
  validates :fund, numericality: { only_integer: true }

  def close_branch
    return false if self.status == false

    self.close_at = Time.now.utc
    self.status = false
    save!(validate: false)
  end

  def open_branch
    return false if self.status == true

    self.open_at = Time.now.utc
    self.status = true
    save!(validate: false)
  end

  def create_address
    address = Address.find_or_create_by(full_address: self.full_address, postal_code: self.postal_code)
    self.address_id = address.id
  end
end
