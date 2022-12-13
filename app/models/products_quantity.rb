class ProductsQuantity < ApplicationRecord
  belongs_to :products_branch

  enum :type, { inbound: 0, outbound: 1 }, prefix: true
end
