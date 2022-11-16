class Inventory < ApplicationRecord
  has_many :products
  has_many :products, as: :parent
  has_one :company
  has_one :address
end
