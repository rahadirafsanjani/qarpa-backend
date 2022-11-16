class Product < ApplicationRecord
  attr_accessor :items
  belongs_to :supplier
  # belongs_to :inventory
  belongs_to :parent, :polymorphic => true
  has_many :detail_order
  has_many :orders, through: :detail_order
  # image
  has_one_attached :image, :dependent => :destroy
  # validate :acceptable_image
  def image_url
    Rails.application.routes.url_helpers.url_for(image) if image.attached?
  end

  def self.insert_product_delivered params = {}
    shipping = Shipping.find_by(id: params[:id])
    product_id = []
    item_shippings = ItemShipping.where(shipping_id: params[:id])
    item_shippings.each do |item_shipping|
      product_id << item_shipping.product_id
    end

    products = Product.where(id: product_id)
    insert_value = []
    item_shippings.each do |item_shipping|
      products.each do |product|
        if product.id == item_shipping.product_id
          insert_value << {
             "name": product.name,
             "quantity": product.quantity,
             "quantity_type": product.quantity_type,
             "category": product.category,
             "expire": product.expire,
             "price": product.price,
             "supplier_id": product.supplier_id,
             "parent_id": product.parent.id,
             "parent_type": product.parent_type
           }
        end
      end
    end

    branch = Branch.find_by(id: shipping.branch_id)
    insert_value.each do |value|
      branch.products.find_or_create_by(value)
      item_shippings.each do |item_shipping|
        total = value[:quantity].to_i + item_shipping.quantity
        branch.products.update(quantity: total)
      end
    end
  end

  def self.get_all_products params = {}
    products = Product.includes(:supplier).where(params)
    products.map do |product|
      product.new_response
    end
  end

  def new_response
    {
      "id": self.id,
      "name": self.name,
      "quantity": self.quantity,
      "quantity_type": self.quantity_type,
      "category": self.category,
      "expire": self.expire,
      "price": self.price,
      "image": self.image_url,
      "supplier": {
        id: self.supplier.id,
        name: self.supplier.name
      }
    }
  end

  private
  def acceptable_image
    unless image.byte_size <= 1.megabyte
      errors.add(:image, "is too big")
    end
    acceptable_types = ["image/jpeg", "image/png"]
    unless acceptable_types.include?(image.content_type)
      errors.add(:image, "must be a JPEG or PNG")
    end
  end

end
