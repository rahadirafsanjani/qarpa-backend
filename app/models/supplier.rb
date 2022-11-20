class Supplier < ApplicationRecord
  has_many :products, through: :product_shared
  has_many :product_shared

  def self.dropdown
    @suppliers = Supplier.all
    @suppliers.map do |supplier|
      supplier.dropdown_attribute
    end
  end

  def dropdown_attribute
    {
      "id": self.id,
      "value": self.name
    }
  end
end
