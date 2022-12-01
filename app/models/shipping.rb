class Shipping < ApplicationRecord
  attr_accessor :items

  after_create_commit :reduce_stock, :save_shipping_item
  before_create :get_products, :validate_stock_products

  has_many :item_shippings
  belongs_to :origin, class_name: "Address", foreign_key: "origin_id"
  belongs_to :destination, class_name: "Address", foreign_key: "destination_id"
  belongs_to :branch, optional: true
  belongs_to :customer, optional: true

  enum status: { prepared: 0, delivering: 1, delivered: 2 }

  # def validate_stock_products
  #   valid = 0
  #
  #   self.items.each do |item|
  #     @products.each do |product|
  #       if product.id == item[:product_id] && product.quantity < item[:quantity]
  #         errors.add(:quantity, "#{product.name} not enough stock")
  #         valid = valid + 1
  #       end
  #     end
  #   end
  #
  #   raise ActiveRecord::Rollback unless valid.zero?
  # end


  # def reduce_stock
  #   self.items.each do |item|
  #     @products.each do |product|
  #       if product.id == item[:product_id]
  #         product[:quantity] = product[:quantity] - item[:quantity]
  #         product.save!(validate: false)
  #       end
  #     end
  #   end
  # end

  def get_products
    @products = Product.where(id: get_product_id)
  end

  def get_product_id
    return self.items.map do |item|
      item[:product_id]
    end
  end

  # def save_shipping_item
  #   self.item_shippings.insert_all(self.items)
  # end
end
