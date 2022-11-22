class ProductShared < ApplicationRecord
  has_many :detail_orders
  has_many :orders, through: :detail_orders

  belongs_to :parent, polymorphic: true
  belongs_to :product
  belongs_to :supplier, optional: true

  def self.create_from_branch params = {}
    @branch = Branch.find_by(id: params[:id])
    @product = Product.find_or_create_by(name: params[:name], category_id: params[:category_id])
    @product_shareds = ProductShared.new(qty: params[:qty], price: params[:price], expire: params[:expire], product_id: @product.id, parent_id: @branch.id, parent_type: "Branch")
    @product_shareds.save(validate: false)
    return false unless @product_shareds.valid?
    @product_shareds.product_attribute
  end

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
      "category.rb": self.product.category || nil,
      "expire": self.expire,
      "price": self.price,
      "image": self.product.image_url || nil
    }
  end
end