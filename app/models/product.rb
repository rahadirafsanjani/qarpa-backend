class Product < ApplicationRecord
  attr_accessor :qty, :price, :expire, :company_id, :name_supplier

  belongs_to :supplier, optional: true
  belongs_to :category
  has_many :product_shareds
  has_many :detail_order
  has_many :orders, through: :detail_order

  # image
  has_one_attached :image, :dependent => :destroy

  def self.units 
    [
      {
        "value": "Satuan"
      },{
        "value": "Kardus"
      }
    ]
  end

  def self.condition_products 
    [
      {
        "value": "Bagus",
      },{
        "value": "Rusak"
      },{
        "value": "Kadaluarsa"
      }
    ]
  end

  # validate :acceptable_image

  after_create_commit :product_shareds_inventory

  def image_url
    Rails.application.routes.url_helpers.url_for(image) if image.attached?
  end

  def self.show_all_product params = {}
    @product = []
    @inventory = Inventory.find_by(id: params[:inventory_id])
    @inventory.product_shareds.each do |product_shared|
      @product << {
        "id": product_shared.id,
        "name": product_shared.product.name,
        "qty": product_shared.qty,
        "price": product_shared.price,
        "category": product_shared.product.category.name,
        "image": product_shared.product.image_url 
      }
    end

    @product
  end

  def product_shareds_inventory params = {}
    @supplier = Supplier.find_or_create_by(name: self.name_supplier)
    @inventory = Inventory.find_by(company_id: self.company_id)
    new_product_shareds = {
      product_id: self.id,
      expire: self.expire,
      price: self.price,
      qty: self.qty,
      supplier_id: @supplier.id,
    }
    if new_product_shareds[:product_id].present?
      ProductShared.insert(new_product_shareds.merge(parent_id: @inventory.id, parent_type: "Inventory"))
    end
  end

  def self.update_product_branch params = {}
    @product_shared = ProductShared.find_by(id: self.id)
    update_value = {
      name: self.name,
      image: self.image
    }
    product = Product.find_by(id: @product_shared.product_id)
    @product = product.update(update_value)
    return @product
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
