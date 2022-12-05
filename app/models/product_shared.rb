class ProductShared < ApplicationRecord
  has_many :detail_orders
  has_many :orders, through: :detail_orders

  belongs_to :branch
  belongs_to :product
  belongs_to :supplier, optional: true

  def self.get_index
    @product_shared = ProductShared.all
    @product_shared.map do | product |
      product.product_attribute
    end
  end

  def self.get_by_id params = {}
    @product_shared = ProductShared.find_by(id: params[:id])
    @product_shared.product_attribute
  end

  def self.get_product_branch params = {}
    @branch = Branch.find_by(id: params[:branch_id])
    @branch.product_shareds.map do |product_shared|
      product_shared.product_attribute
    end
  end

  def self.sum_qty params = {}
    @product_shared = ProductShared.find_by(supplier_id: params[:supplier_id], branch_id: params[:branch_id], product_id: params[:product_id])
    if @product_shared.blank?
      @product_shared = ProductShared.create(qty: params[:new_qty], selling_price: params[:selling_price],
                        purchase_price: params[:purchase_price], expire: params[:expire],
                        branch_id: params[:branch_id], supplier_id: params[:supplier_id], product_id: params[:product_id])
    else
      sum = @product_shared.qty + params[:new_qty].to_i
      @product_shared.update(qty: sum)
    end
    return @product_shared
  end

  def self.update_product params = {}
    @product_shared = ProductShared.find_by(id: params[:product_shared_id])
    @product_shared.update(qty: params[:qty],
                           selling_price: params[:selling_price],
                           branch_id: params[:branch_id])
    @product = Product.find_by(id: @product_shared.product_id)
    @product.update(name: params[:name], category_id: params[:category_id])
    @product_shared.product_attribute
  end

  def self.add_through_report params = {}
    report = {
      name: params[:name],
      qty: params[:qty],
      purchase_price: params[:purchase_price],
      company_id: params[:company_id]
    }
    @report = ProductReport.insert(report)
  end

  def product_attribute
    {
      "id": self.id,
      "name": self.product.name || nil,
      "qty": self.qty,
      "quantity_type": self.product.quantity_type || nil,
      "category": self.product.category.id || nil,
      "expire": self.expire,
      "selling_price": self.selling_price,
      "image": self.product.image_url || nil,
      "branch_id": self.branch_id
    }
  end
end