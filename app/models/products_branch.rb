class ProductsBranch < ApplicationRecord
  attr_accessor :qty
  has_many :detail_orders
  has_many :orders, through: :detail_orders
  has_many :products_quantities, dependent: :destroy

  belongs_to :branch
  belongs_to :product
  belongs_to :supplier, optional: true


  def self.qty_create params = {}
    create_qty = []
    new_product_qty_in = {
      qty: params[:qty],
      qty_type: 0,
      products_branch_id: params[:products_branch_id]
    }
    create_qty << new_product_qty_in
    if create_qty.present?
      ProductsQuantity.create(create_qty)
    end
  end

  def self.get_index
    # all_product = []
    #
    # @products_branch = ProductsBranch.all
    # @products_branch.map do | product |
    #   all_product << {
    #       "id": product.id,
    #       "name": product.product.name || nil,
    #       "qty": product.products_quantities.first.qty || nil,
    #       "quantity_type": product.product.quantity_type || nil,
    #       "category": product.product.category.id || nil,
    #       "selling_price": product.selling_price || nil,
    #       "image": product.product.image_url || nil,
    #       "branch_id": product.branch_id || nil,
    #   }
    # end
    #
    return "under maintain"
  end

  def self.get_by_id params = {}
    @products_branch = ProductsBranch.find_by(id: params[:id])
    @products_branch.product_attribute
  end

  def self.get_products_branch params = {}
    products_branch = ProductsBranch.where(branch_id: params[:branch_id])
    products_branch.map do |product|
      product.new_product_attribute
    end
  end

  def new_product_attribute 
    sum_inbound = self.products_quantities.where(products_quantities: { :qty_type => 0 }).sum(:qty)
    sum_outbound = self.products_quantities.where(products_quantities: { :qty_type => 1 }).sum(:qty)
    sum_quantities = sum_inbound - sum_outbound
    {
        "id": self.id,
        "name": self.product.name,
        "qty": sum_quantities,
        "quantity_type": self.product.quantity_type,
        "category": self.product.category.id,
        "selling_price": self.selling_price,
        "image": self.product.image_url,
        "branch_id": self.branch_id
    }
  end

  def self.create_product_branch params = {}
    @products_branch = ProductsBranch.find_by(supplier_id: params[:supplier_id], branch_id: params[:branch_id], product_id: params[:product_id])
    if @products_branch.blank?
      @products_branch = ProductsBranch.create(selling_price: params[:selling_price], purchase_price: params[:purchase_price], branch_id: params[:branch_id], supplier_id: params[:supplier_id], product_id: params[:product_id])
    else
      @qty = ProductsQuantity.create(qty: params[:qty], qty_type: 0, products_branch_id: @products_branch.id)
    end
  end

  def self.update_product params = {}
    old_qty = 0
    new_qty = params[:qty].to_i
    @products_branch = ProductsBranch.find_by(id: params[:products_branch_id])
    @product = Product.find_by(id: @products_branch.product_id)
    @product_qty = ProductsQuantity.where(products_branch_id: @products_branch.id, qty_type: 0)
    @product_qty.map do | qty |
      old_qty += qty.qty
    end
    sum = new_qty*2 - old_qty
    if @products_branch.present? && @product.present?
      @products_branch.update(selling_price: params[:selling_price], branch_id: params[:branch_id])
      @product.update(name: params[:name], category_id: params[:category_id])
      ProductsQuantity.create(qty: sum, qty_type: 0, products_branch_id: @products_branch.id)
      @product.image.attach(params[:image]) if params[:image].present?
      @products_branch.product_attribute
    end
  end

  def self.delete_product_branch params = {}
    @delete_product = ProductsBranch.find_by(id: params[:id])
    return @delete_product ? @delete_product.delete : @delete_product.errors
  end

  def get_qty
    @product_qty = []
    @attrbute = ProductsQuantity.where(products_branch_id: self.id)
    @attrbute.map do | attr |
      qty = {
        "qty_type": attr.qty_type,
        "qty": attr.qty
      }
      @product_qty << qty
    end

    return @product_qty
  end

  def product_attribute
    {
      "id": self.id,
      "name": self.product.name || nil,
      "qty": get_qty || nil,
      "quantity_type": self.product.quantity_type || nil,
      "category": self.product.category.id || nil,
      "selling_price": self.selling_price,
      "image": self.product.image_url || nil,
      "branch_id": self.branch_id
    }
  end
end
