class Inventory < ApplicationRecord
  has_many :product_shareds, as: :parent
  has_one :company
  has_one :address
end
