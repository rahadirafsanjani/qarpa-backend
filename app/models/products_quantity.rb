class ProductsQuantity < ApplicationRecord
  belongs_to :product_shared

  enum :qty_type, { inbound: 0, outbound: 1 }, prefix: true
end
