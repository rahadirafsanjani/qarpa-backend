class Product < ApplicationRecord
  attr_accessor :items
  belongs_to :supplier, :optional => true
  belongs_to :category
  belongs_to :product_shared
  has_many :detail_order
  has_many :orders, through: :detail_order

  # image
  has_one_attached :image, :dependent => :destroy
  # validate :acceptable_image

  after_save :product_shareds_inventory

  def image_url
    Rails.application.routes.url_helpers.url_for(image) if image.attached?
  end

  def product_shareds_inventory params = {}
    Product_shared.create(supplier_id: @supplier.id,
                          product_id: @product.id,
                          price: params[:price],
                          qty: params[:quantity],
                          parent: Inventory.find_by(company_id: @user.company_id))
  end

  def self.insert_product_delivered params = {}
    shipping = Shipping.find_by(id: params[:id])
    item_shippings = ItemShipping.where(shipping_id: shipping.id)
    item_shippings.each do |item_shipping|
      product_id << item_shipping.product_id
      products = Product.where(id: product_id)
      product_updated
    end
  end

  def self.get_all_products params = {}
    products = Product.includes(:supplier).where(params)
    products.map do |product|
      product.new_response
    end
  end

  def supplier_attribute
    {
      "id": self.supplier.id,
      "name": self.supplier.name
    }
  end

  def product_attribute
    {
      "id": self.id,
      "name": self.name,
      "quantity": self.quantity,
      "quantity_type": self.quantity_type,
      "category.rb": self.category,
      "expire": self.expire,
      "price": self.price,
      "image": self.image_url
    }
  end

  def new_response
    if supplier.nil?
      product_attribute
    else
      product_attribute.merge(supplier: supplier_attribute)
    end
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
