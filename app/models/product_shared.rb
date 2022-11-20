class ProductShared < ApplicationRecord
  belongs_to :parent, polymorphic: true
  belongs_to :product
  belongs_to :supplier
end