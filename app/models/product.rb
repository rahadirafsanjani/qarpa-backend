class Product < ApplicationRecord
  attr_accessor :qty, :purchase_price, :selling_price, :expire, :supplier_id, :branch_id

  belongs_to :supplier, optional: true
  belongs_to :category
  has_many :products_branches
  has_many :detail_order
  has_many :orders, through: :detail_order

  has_one_attached :image, :dependent => :destroy
  after_create_commit :products_branches_create

  validate :acceptable_image

  def image_url
    Rails.application.routes.url_helpers.url_for(image) if image.attached?
  end

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

  def products_branches_create
    @branch = Branch.find_by(id: self.branch_id)
    new_product = {
      product_id: self.id,
      # little bit stupid but its hafiz says
      purchase_price: self.selling_price || nil,
      selling_price: self.selling_price,
      supplier_id: self.supplier_id || nil
    }
    if new_product[:product_id].present?
      add_qty = ProductsBranch.create(new_product.merge(branch_id: @branch.id))
      ProductsBranch.qty_create(qty: self.qty, products_branch_id: add_qty.id)
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
      "id": self.supplier.id || nil,
      "name": self.supplier.name || nil
    }
  end

  def product_attribute
    {
      "id": self.id,
      "name": self.name,
      "qty": self.quantity,
      "quantity_type": self.quantity_type,
      "category": self.category,
      "expire": self.expire,
      "selling_price": self.selling_price,
      # little bit stupid but its hafiz says
      "purchase_price": self.selling_price || nil,
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
    if image.attached?
      unless image.byte_size <= 1.megabyte
        errors.add(:image, "is too big")
      end
      acceptable_types = ["image/jpeg", "image/png"]
      unless acceptable_types.include?(image.content_type)
        errors.add(:image, "must be a JPEG or PNG")
      end
    end
  end

end
