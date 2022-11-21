class ProductShared < ApplicationRecord
  has_many :detail_orders
  has_many :orders, through: :detail_orders

  belongs_to :parent, polymorphic: true
  belongs_to :product
  belongs_to :supplier
end