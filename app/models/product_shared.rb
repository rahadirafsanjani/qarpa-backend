class Product_shared < ApplicationRecord
  belongs_to :supplier
  belongs_to :product
end