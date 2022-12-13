class ProductsQuantity < ApplicationRecord
  belongs_to :product_shareds

  enum :type, { inbound: 0, outbound: 1 }, prefix: true
end
