class Supplier < ApplicationRecord
  attr_accessor :full_address
  before_validation :create_address

  has_many :products, through: :product_shared
  has_many :product_shareds

  belongs_to :address

  validate :validate_address
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, :phone, :email, presence: true
  validates :phone, numericality: { only_integer: true }

  def self.dropdown params = {}
    @suppliers = Supplier.where(company_id: params[:company_id])
    @suppliers.map do |supplier|
      supplier.dropdown_attribute
    end
  end

  def supplier_attribute 
    {
      "id": self.id,
      "name": self.name,
      "address": self.address.full_address,
      "email": self.email,
      "phone": self.phone
    }
  end

  def dropdown_attribute
    {
      "id": self.id,
      "value": self.name
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
