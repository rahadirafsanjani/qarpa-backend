class ProductShared < ApplicationRecord
  has_many :detail_orders
  has_many :orders, through: :detail_orders

  belongs_to :branch
  belongs_to :product
  belongs_to :supplier, optional: true

  def self.get_product_branch params = {}
    @branch = Branch.find_by(id: params[:branch_id])
    @branch.product_shareds.map do |product_shared|
      product_shared.product_attribute
    end
  end

  def self.sum_qty params = {}
    @product_shared = ProductShared.find_by(supplier_id: params[:supplier_id], branch_id: params[:branch_id], product_id: params[:product_id])
    sum = @product_shared.qty + params[:new_qty].to_i

    ProductShared.update(qty: sum)
  end

  def product_attribute
    {
      "id": self.id,
      "name": self.product.name || nil,
      "qty": self.qty,
      "quantity_type": self.product.quantity_type || nil,
      "category.rb": self.product.category.name || nil,
      "expire": self.expire,
      "selling_price": self.selling_price,
      "image": self.product.image_url || nil
    }
  end
end