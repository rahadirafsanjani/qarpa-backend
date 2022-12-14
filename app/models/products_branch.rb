class ProductsBranch < ApplicationRecord
  attr_accessor :qty
  has_many :detail_orders
  has_many :orders, through: :detail_orders
  has_many :products_quantities

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
    new_product_qty_out = {
      qty: 0,
      qty_type: 1,
      products_branch_id: params[:products_branch_id]
    }
    create_qty << new_product_qty_in
    create_qty << new_product_qty_out
    if create_qty.present?
      ProductsQuantity.insert_all(create_qty)
    end
  end

  def self.get_index
    all_product = []

    @products_branch = ProductsBranch.all
    @products_branch.map do | product |
      all_product << {
          "id": product.id,
          "name": product.product.name || nil,
          "qty": product.products_quantities.first.qty || nil,
          "quantity_type": product.product.quantity_type || nil,
          "category": product.product.category.id || nil,
          "selling_price": product.selling_price || nil,
          "image": product.product.image_url || nil,
          "branch_id": product.branch_id || nil,
      }
    end

    return all_product
  end

  def self.get_by_id params = {}
    @products_branch = ProductsBranch.find_by(id: params[:id])
    @products_branch.product_attribute
  end

  def self.get_product_branch params = {}
    all_product = []
    @branch = Branch.find_by(id: params[:branch_id])
    @product_branch = ProductsBranch.where(branch_id: @branch.id)
    @product_branch.each do |product|
      all_product << {
        "id": product.id,
        "name": product.product.name || nil,
        "qty": product.products_quantities.where(:products_quantities => { :qty_type => 0}).sum(:qty) || nil,
        "quantity_type": product.product.quantity_type || nil,
        "category": product.product.category.id || nil,
        "selling_price": product.selling_price,
        "image": product.product.image_url || nil,
        "branch_id": product.branch_id
      }
    end

    all_product
  end

  def self.create_product_branch params = {}
    @products_branch = ProductsBranch.find_by(supplier_id: params[:supplier_id], branch_id: params[:branch_id], product_id: params[:product_id])
    if @products_branch.blank?
      @products_branch = ProductsBranch.create(selling_price: params[:selling_price], purchase_price: params[:purchase_price],
                                              branch_id: params[:branch_id], supplier_id: params[:supplier_id], product_id: params[:product_id])
    else
      @qty = ProductsQuantity.find_by(products_branch_id: @products_branch.id, qty_type: 0)
      sum = @qty.qty + params[:new_qty].to_i
      @qty.update_attribute(:qty, sum)
    end
  end

  def self.update_product params = {}
    @products_branch = ProductsBranch.find_by(id: params[:products_branch_id])
    @products_branch.update(selling_price: params[:selling_price],
                           branch_id: params[:branch_id])
    @product = Product.find_by(id: @products_branch.product_id)
    @product_qty = ProductsQuantity.find_by(products_branch_id: @products_branch.id, qty_type: 0)
    @product.update(name: params[:name], category_id: params[:category_id])
    @product_qty.update(qty: params[:qty])
    @products_branch.product_attribute
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
