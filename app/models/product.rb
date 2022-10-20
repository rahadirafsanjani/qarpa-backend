class Product < ApplicationRecord
  belongs_to :supplier
  has_many :detail_order
  has_many :orders, through: :detail_order
end
