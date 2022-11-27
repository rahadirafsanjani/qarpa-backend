class ProductShared < ApplicationRecord
  has_many :detail_orders
  has_many :orders, through: :detail_orders

  belongs_to :parent, polymorphic: true
  belongs_to :product
  belongs_to :supplier, optional: true

  def self.get_product_branch params = {}
    @branch = Branch.find_by(id: params[:branch_id])
    @branch.product_shareds.map do |product_shared|
      product_shared.product_attribute
    end
  end
  def product_attribute
    {
      "id": self.id,
      "name": self.product.name || nil,
      "quantity": self.qty,
      "quantity_type": self.product.quantity_type || nil,
      "category.rb": self.product.category.name || nil,
      "expire": self.expire,
      "selling_price": self.selling_price,
      "image": self.product.image_url || nil
    }
  end
end