class Shipping < ApplicationRecord
  attr_accessor :items

  after_create_commit :reduce_stock, :save_shipping_item
  before_create :get_products_form, :validate_stock_products, :validate_product_destination

  has_many :item_shippings
  belongs_to :origin, class_name: "Address", foreign_key: "origin_id"
  belongs_to :destination, class_name: "Address", foreign_key: "destination_id"
  belongs_to :branch, optional: true

  enum status: { prepared: 0, delivered: 1 }

  def validate_stock_products
    valid = 0
    self.items.each do |item|
      @product_from.each do |product|
        if product.id == item[:product_shared_id] && product.qty < item[:qty]
          errors.add(:qty, "#{product.name} not enough stock")
          valid += 1
        end
      end
    end

    raise ActiveRecord::Rollback unless valid.zero?
  end

  def reduce_stock
    self.items.each do |item|
      @product_from.each do |product|
        if product.id == item[:product_shared_id]
          product[:qty] -= item[:qty]
          product.save!(validate: false)
        end
      end
    end
  end

  def validate_product_destination
    self.items.map do | item |
    @product_from.each do | product |
      @product_shared_to = ProductShared.find_by(product_id: product.product_id, branch_id: self.destination_id)
        if @product_shared_to.blank?
          new_product = {
            qty: item[:qty],
            product_id: product.product_id,
            branch_id: self.destination_id,
            selling_price: product.selling_price,
            supplier_id: product.supplier_id,
            expire: product.expire,
            purchase_price: product.purchase_price
          }
          ProductShared.insert(new_product)
          else
          @product_shared_to.qty += item[:qty]
          @product_shared_to.save!(validate: false)
        end
      end
    end
  end

  def self.shipping_history
    @report = []
    @report_product = ProductReport.all
    @report_shipping = Shipping.all
    attribute_product = {
      "id": @report_product.id,
      "name": @report_product.name,
      "date": @report_product.created_at,
      "type": "Supplier"
    }
    attribute_shipping = {
      "id": @report_shipping.id,
      "branch_delivered": @report_shipping.destination_id,
      "date": @report_shipping.created_at,
      "type": "Shipping"
    }
    @report << attribute_product
    @report << attribute_shipping
    return @report
  end
  
  def get_products_form
    @product_from = ProductShared.where(id: get_product_shared_id)
  end

  def get_product_shared_id
    return self.items.map do |item|
      item[:product_shared_id]
    end
  end

  def save_shipping_item
    self.item_shippings.insert_all(self.items)
  end
end
