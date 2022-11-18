class Supplier < ApplicationRecord
  has_many :products

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
