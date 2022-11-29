class Order < ApplicationRecord
  attr_accessor :items
  after_save :create_detail_orders, :reduce_stock
  before_save :get_products, :validate_stock_products

  has_many :detail_orders
  has_many :product_shareds, through: :detail_orders
  belongs_to :pos
  belongs_to :customer

  validate :validate_params
  validates :payment, presence: true

  enum :payment, { cash: 0, transfer: 1 }

  private 

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
    valid = 0

    self.items.each do |item|
      @products.each do |product|
        if product.id == item[:product_shared_id] && product.qty < item[:qty]
          errors.add(:qty, "#{product.product.name} not enough stock")
          valid = valid + 1
        end
      end 
    end

    raise ActiveRecord::Rollback unless valid.zero?
  end

  def reduce_stock 
    self.detail_orders.each do |detail_order|
        detail_order.product_shared.qty = detail_order.product_shared.qty - detail_order.qty
        detail_order.product_shared.save!(validate: false)
    end
  end

  def get_products 
    @products = ProductShared.where(id: get_product_id)
  end

  def get_product_id 
    return self.items.map { |item| item[:product_shared_id] }
  end

  def create_detail_orders
    self.detail_orders.create(self.items)
  end
end
