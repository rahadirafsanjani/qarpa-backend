class Order < ApplicationRecord
  attr_accessor :items
  after_save :create_detail_orders, :reduce_stock
  before_save :validate_stock_products
  before_validation :set_default 

  has_many :detail_orders
  has_many :products_branches, through: :detail_orders
  belongs_to :pos
  belongs_to :customer

  validate :validate_params
  validates :payment, presence: true

  enum :payment, { cash: 0, transfer: 1 }

  private 

  def set_default 
    self.customer_id = 0 unless self.customer_id.present?
  end

  def validate_params params = {}
    errors.add(:item, "Item cannot be empty") if self.items.blank?

    if self.items.present?
      self.items.each do |item|
        errors.add(:qty, "Quantity cannot be empty") unless item[:qty].present?
        errors.add(:product_shared_id, "Product shared id cannot be empty") unless item[:product_shared_id].present?
      end
    end

    raise ActiveRecord::Rollback if errors.present?
  end

  def validate_stock_products 
    self.items.each do |item|
      product = ProductShared.find_by(id: item[:product_shared_id])
      stock = ProductsQuantity.group(:qty_type)
                      .where(product_shared_id: item[:product_shared_id])
                      .sum(:qty)
      
      total_stock = (stock['inbound'] || 0) - (stock['outbound'] || 0)
      errors.add(:qty, "#{product.product.name} not enough stock") if item[:qty] > total_stock
    end
    
    raise ActiveRecord::Rollback if errors.present?
  end

  def reduce_stock 
    self.detail_orders.each do |detail_order|
        ProductsQuantity.create(
          product_shared_id: detail_order.product_shared_id, 
          qty: detail_order.qty, qty_type: 1
        )
    end
  end

  def create_detail_orders
    self.detail_orders.create(self.items)
  end
end
