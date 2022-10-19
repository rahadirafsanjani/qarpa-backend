class Product < ApplicationRecord
  has_many :detail_order
  has_many :orders, through: :detail_order
end
