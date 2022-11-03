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
    valid = 0

    self.items.each do |item|
      @products.each do |product|
        if product.id == item[:product_id] && product.quantity < item[:qty]
          errors.add(:qty, "#{product.name} not enough stock")
          valid = valid + 1
        end
      end 
    end

    raise ActiveRecord::Rollback unless valid.zero?
  end

  def reduce_stock 
    self.items.each do |item| 
      @products.each do |product|
        if product.id == item[:product_id]
          product[:quantity] = product[:quantity] - item[:qty]
          product.save!(validate: false)
        end
      end
    end
  end

  def get_products 
    @products = Product.where(id: get_product_id)
  end

  def get_product_id 
    return self.items.map do |item|
      item[:product_id]
    end
  end

  def create_detail_orders
    self.detail_orders.insert_all(self.items)
  end
end
