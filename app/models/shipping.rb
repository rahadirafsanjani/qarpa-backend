class Shipping < ApplicationRecord
  attr_accessor :items, :branch_id

  has_many :item_shippings
  belongs_to :origin, class_name: "Branch", foreign_key: "origin_id"
  belongs_to :destination, class_name: "Branch", foreign_key: "destination_id"
  belongs_to :branch, optional: true

  after_create_commit :reduce_stock, :save_shipping_item
  before_create :get_products_to, :validate_stock_products, :validate_product_destination

  def validate_stock_products
    valid = 0
    self.items.each do |item|
      @product_from_inbound.each do |product|
        if product.products_branch_id == item[:products_branch_id] && @sum_in < item[:qty]
            errors.add(:qty, "#{product.products_branch.product.name} not enough stock")
            valid += 1
        end
      end
    end
    raise ActiveRecord::Rollback unless valid.zero?
  end

  def reduce_stock
    self.items.each do |item|
      @product_from_inbound.each do | product |
        if product.products_branch_id == item[:products_branch_id]
          ProductsQuantity.create(qty: item[:qty], qty_type: 1, products_branch_id: item[:products_branch_id])
        end
      end
    end
  end

  def validate_product_destination
    self.items.each do |item|
      product = ProductsBranch.find_by(id: item[:products_branch_id])
      destination_product = ProductsBranch.find_by(product_id: product.product_id, branch_id: self.destination_id)
      # create new product qty on new branch
      if destination_product.blank?
        new_product = {
          product_id: product.product_id,
          branch_id: self.destination_id,
          selling_price: product.selling_price,
          supplier_id: product.supplier_id,
          # little bit stupid but its hafiz says
          purchase_price: product.selling_price
        }
        @pb = ProductsBranch.create(new_product)
        ProductsBranch.qty_create(products_branch_id: @pb.id, qty: item[:qty])
      else
        # if there was product qty add it
        if product.id == item[:products_branch_id]
          @qty = ProductsQuantity.create(products_branch_id: destination_product.id, qty_type: 0, qty: item[:qty])
        end

      end
    end
  end

  def self.shipping_history params = {}
    conditions = {}
    conditions.merge!(company_id: params[:company_id]) if params[:company_id].present?
    conditions.merge!(id: params[:branch_id]) if params[:branch_id].present?

    reports = []
    reports_shippings = Shipping.joins(
      "
      LEFT JOIN branches ON branches.id = shippings.destination_id 
      "
    ).select(
      "
      shippings.id,
      branches.name,
      shippings.created_at
      "
    ).where(branches: conditions)

    reports_suppliers = Branch.joins(
      "
      LEFT JOIN products_branches ON products_branches.branch_id = branches.id
      LEFT JOIN suppliers ON suppliers.id = products_branches.supplier_id
      LEFT JOIN products_quantities ON products_quantities.products_branch_id = products_branches.id
      "
    ).select(
      "
      products_branches.id,
      suppliers.name,
      products_quantities.created_at
      "
    ).where(conditions.merge!(products_quantities: { qty_type: 0 }))

    shipping_attribute = {}

    reports_suppliers.each do |report |
      reports << {
        "id": report.id,
        "supplier_name": report.name,
        "date": report.created_at.to_date,
        "type": "supplier"
      }
    end

    reports_shippings.each do |report |
      reports << {
        "id": report.id,
        "branch_name": report.name,
        "date": report.created_at.to_date,
        "type": "shipping"
      }
    end

    reports
  end

  def get_products_to
    @sum_in = 0
    @product_from_inbound = ProductsQuantity.where(products_branch_id: get_products_branch_id, qty_type: 0)
    @product_from_inbound.each do | qty |
      @sum_in += qty[:qty]
    end
    @product_from_outbound = ProductsQuantity.where(products_branch_id: get_products_branch_id, qty_type: 1)
  end

  def get_products_branch_id
    return self.items.map do |item|
      item[:products_branch_id]
    end
  end

  def save_shipping_item
    self.item_shippings.insert_all(self.items)
  end
end
