class Order < ApplicationRecord
  attr_accessor :item
  after_save :create_detail_orders

  has_many :detail_orders
  has_many :product, through: :detail_orders
  belongs_to :branch
  belongs_to :user
  belongs_to :customer

  validates :payment_method, presence: true

  private 

  def create_detail_orders
    detail_order = self.item.map do |item|
      item[:order_id] = self.id
    end
    
    DetailOrder.create(self.item)
  end
end
