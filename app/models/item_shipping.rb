class ItemShipping < ApplicationRecord
  belongs_to :shipping
  belongs_to :product
end
