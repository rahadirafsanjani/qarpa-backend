class Api::V1::ProductsController < ApplicationController
  before_action :authorize
  before_action :set_inventory_env, only: %i[ new_product ]

  def new_product
    category_id = Category.find_by(id: params[:category])
    @product = Product.new(set_product_from_supplier.merge(category_id))
  end


  private
  def set_product_from_supplier
    params.permit(:name, :expire, :image, :quantity_type)
  end
  def set_product_shared
    params.permit(:quantity, :price)
  end
  def set_category
    params.permit(:category)
  end
  def set_product_on_branch
    params.permit(:name, :qty, :expire, :price, :image)
  end
  def new_product_from_supplier
    @supplier = Supplier.find_or_create_by(name: params[:name_supplier])
  end
  def pick_product
    @product = Product.find_by(id: params[:id])
  end
  def set_inventory_env
    @inventory = Inventory.find_by(company_id: @user.company_id)
  end
  def set_branch_env
    @branch = Branch.find_by(id: params[:id])
  end
end
