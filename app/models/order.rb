class Order < ApplicationRecord
  attr_accessor :items
  after_save :create_detail_orders, :reduce_stock
  before_save :get_products, :validate_stock_products

  has_many :detail_orders
  has_many :product, through: :detail_orders
  belongs_to :pos
  belongs_to :customer

  private 

  def validate_stock_products
    @request = self.items
    @request.each do |item|
      @products.each do |product|
        if product.quantity < item[:qty]
          errors.add(:qty, "#{product.name} not enough stock")
          raise ActiveRecord::Rollback
        end
      end 
    end
  end

  def reduce_stock 
    @products.map do |product|
      @request.each do |request|
        if product[:id] == request[:product_id]
          product[:quantity] = product[:quantity] - request[:qty]
          product.save!(validate: false)
        end
      end
    end
  end

  def get_products 
    products_id = self.items.map do |item|
      item[:product_id]
    end
    
    @products = Product.where(id: products_id)
  end

  def create_detail_orders
    self.items.map do |item|
      item[:order_id] = self.id
    end
    
    DetailOrder.insert_all(self.items)
  end
end
