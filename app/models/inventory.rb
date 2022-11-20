class Inventory < ApplicationRecord
  has_one :company
  has_one :address
end
