class Branch < ApplicationRecord
  attr_accessor :full_address
  before_validation :validate_address, :create_address
  
  belongs_to :address 
  belongs_to :company
  has_many :pos, class_name: "Pos", foreign_key: "branch_id"
  has_many :users 
  
  validates :name, :phone, presence: true

  def self.get_all_branch params = {}
    branches = Branch.includes(:address).where(params)
    branches.map do |branch|
      branch.new_response
    end
  end

  def new_response 
    {
      "id": self.id,
      "company_id": self.company_id,
      "name": self.name,
      "address": self.address.full_address,
      "status": self.status,
      "phone": self.phone
    }
  end

  def open_branch 
    self.status = true 
    save!(validate: false)
  end

  def close_branch
    self.status = false
    self.save!(validate: false)
  end

  private

  def validate_address 
    errors.add(:full_address, "Full address cannot be blank") if self.full_address.blank?
    raise ActiveRecord::Rollback if self.full_address.blank?
  end

  def create_address
    address = Address.find_or_create_by(full_address: self.full_address)
    self.address_id = address.id
  end
end
