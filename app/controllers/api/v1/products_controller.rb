class Api::V1::ProductsController < ApplicationController
  before_action :authorize
  before_action :set_product, only: %i[ update_product show_product_by_id delete_product]
  before_action :get_inventory, only: %i[ new_product index update_product delete_product show_product_by_id ]
  before_action :pick_product_parent, only: %i[ update_product_from_branch ]

  # Inventory Scope
  def new_product
    @product = Product.new(set_product_from_supplier)
    if @product.save
      render json: @product
    else
      render json: @product.errors
    end
  end
  def index
    @product = Product.show_all_product(inventory_id: @inventory.id)
    render json: @product
  end
  def show_product_by_id
    render json: @product
  end

  def update_product
    @product.update(set_product_from_supplier)
    render json: @product
  end

  def delete_product
    if @product.delete
    render json: @product
    end
  end

  # Branch/POS Scope
  def get_product_from_branch
    @products = ProductShared.get_product_branch(branch_id: params[:id])
    @products ? response_to_json("List product", @products, :ok) :
      response_error("something went wrong", :unprocessable_entity)
  end

  def create_product_from_branch
    @product = ProductShared.create_from_branch(set_product_from_supplier.merge(id: params[:id]))
    @product ? response_to_json("New product has been created", @product, :ok) :
      response_error("Something went wrong", :unprocessable_entity)
  end



  private
  def set_product_from_supplier
    params.permit(:name, :image, :quantity_type, :qty, :price, :expire, :category_id, :name_supplier).merge(company_id: @user.company_id)
  end

  def set_product_from_branch
    params.permit(:name, :image, :price, :qty, :category_id, :expire)
  end
  def set_product
    @product = Product.find_by(id: params[:id])
    response_error("Product not found", :not_found) unless @product.present?
  end
  def pick_product_parent
    @product_shared = ProductShared.find_by(id: params[:id])
  end
  def get_inventory
    @inventory = Inventory.find_by(company_id: @user.company_id)
  end
  def set_branch_env
    @branch = Branch.find_by(id: params[:id])
  end
end
