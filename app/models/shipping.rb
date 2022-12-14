class Shipping < ApplicationRecord
  attr_accessor :items, :branch_id

  has_many :item_shippings
  belongs_to :origin, class_name: "Address", foreign_key: "origin_id"
  belongs_to :destination, class_name: "Address", foreign_key: "destination_id"
  belongs_to :branch, optional: true

  after_create_commit :reduce_stock, :save_shipping_item
  before_create :get_products_form, :get_products_to, :validate_stock_products, :validate_product_destination

  def validate_stock_products
    valid = 0
    self.items.each do |item|
      @product_to.each do |product|
          if product.products_branch_id == item[:products_branch_id] && product.qty < item[:qty]
            errors.add(:qty, "#{product.products_branch.product.name} not enough stock")
            valid += 1
        end
      end
    end
    raise ActiveRecord::Rollback unless valid.zero?
  end

  def reduce_stock
    self.items.each do |item|
      @product_to.each do | qty |
        if qty.products_branch_id == item[:products_branch_id]
          qty[:qty] += item[:qty]
          qty.save!(validate: false)
        end
      end
    end
  end

  def validate_product_destination
    self.items.each do |item|
      @product_to.each do | qty |
        product = ProductsBranch.find_by(id: item[:products_branch_id])
        destination_product = ProductsBranch.find_by(product_id: product.product_id, branch_id: self.destination_id)
        if destination_product.blank?
          new_product = {
            product_id: product.product_id,
            branch_id: self.destination_id,
            selling_price: product.selling_price,
            supplier_id: product.supplier_id,
            purchase_price: product.purchase_price
          }
          @pb = ProductsBranch.create(new_product)
          sum = qty.qty + item[:qty]
          ProductsBranch.qty_create(products_branch_id: @pb.id, qty: item[:qty])
          qty.update_attribute(:qty, sum)
        else
          if product.id == item[:products_branch_id]
            @qty = ProductsQuantity.find_by(products_branch_id: destination_product.id)
            sum = @qty.qty + item[:qty]
            @qty.update_attribute(:qty, sum)
          end
        end
      end
    end
  end

  def self.shipping_history
    @report = []
    @report_product = ProductReport.all
    @report_shipping = Shipping.all
    @report_shipping.map do | shipping |
      branch_name = Branch.find_by(id: shipping.destination_id)
      attribute_shipping = {
        "id": shipping.id,
        "branch_name": branch_name.name,
        "date": shipping.created_at.to_date,
        "type": "shipping"
      }
      @report << attribute_shipping
    end
    @report_product.map do | product |
      supplier_name = Supplier.find_by(id: product.supplier_id)
        if supplier_name.present?
          attribute_product = {
            "id": product.id,
            "supplier_name": supplier_name.name,
            "date": product.created_at.to_date,
            "type": "supplier"
          }
          @report << attribute_product
        end
      end
    return @report
  end

  def self.shipping_history_branch params = {}
    @report = []
    @report_product = ProductReport.where(branch_id: params[:branch_id])
    @report_shipping = Shipping.where(destination_id: params[:branch_id]).or(Shipping.where(origin_id: params[:branch_id]))
    @report_shipping.map do | shipping |
      branch_name = Branch.find_by(id: shipping.destination_id)
      attribute_shipping = {
        "id": shipping.id,
        "branch_name": branch_name.name,
        "date": shipping.created_at.to_date,
        "type": "shipping"
      }
      @report << attribute_shipping
    end
    @report_product.map do | product |
      supplier_name = Supplier.find_by(id: product.supplier_id)
      if supplier_name.present?
        attribute_product = {
          "id": product.id,
          "supplier_name": supplier_name.name,
          "date": product.created_at.to_date,
          "type": "supplier"
        }
        @report << attribute_product
      end
    end
    return @report
  end


  def get_products_form
    @product_from = ProductsQuantity.where(products_branch_id: get_products_branch_id, qty_type: 0)
  end

  def get_products_to
    @product_to = ProductsQuantity.where(products_branch_id: get_products_branch_id, qty_type: 0)
  end

  def add_out_bound_qty
    @product_to = ProductsQuantity.where(products_branch_id: get_products_branch_id, qty_type: 1)
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
