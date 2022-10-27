class Inventory < ApplicationRecord
  has_many :products
  has_one :company
  has_one :address
end
