class Product < ApplicationRecord
  attr_accessor :qty, :purchase_price, :selling_price, :expire, :supplier_id, :branch_id

  belongs_to :supplier, optional: true
  belongs_to :category
  has_many :products_branches
  has_many :detail_order
  has_many :orders, through: :detail_order

  # image
  has_one_attached :image, :dependent => :destroy
  after_create_commit :product_shareds_branch, :add_through_report

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

  def product_shareds_branch params = {}
    @branch = Branch.find_by(id: self.branch_id)
    # @supplier = Supplier.find_by(id: self.supplier_id)
    new_product_shareds = {
      product_id: self.id,
      expire: self.expire,
      purchase_price: self.purchase_price,
      selling_price: self.selling_price,
      qty: self.qty,
      supplier_id: self.supplier_id || nil
    }
    if new_product_shareds[:product_id].present?
      ProductsBranch.insert(new_product_shareds.merge(branch_id: @branch.id))
    end
  end

  def add_through_report
    branch_name = Branch.find_by(id: self.branch_id)
    company = Company.find_by(id: branch_name.company_id)
    report = {
      name: self.name,
      qty: self.qty,
      purchase_price: self.purchase_price,
      company_id: company.id,
      supplier_id: self.supplier_id,
      branch_id: self.branch_id
    }
    @report = ProductReport.insert(report)
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
      "purchase_price": self.purchase_price,
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
