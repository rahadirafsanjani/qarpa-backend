class Api::V1::ProductsController < ApplicationController
  before_action :authorize
  before_action :set_product, only: %i[ update_product delete_product]
  before_action :pick_product_parent, only: %i[ update_product_from_branch ]

  def new_product
    @product = Product.new(set_product_from_supplier)
    if @product.save
      render json: @product
    else
      render json: @product.errors
    end
  end

  def index
    @product = ProductShared.all
    render json: @product
  end

  def show_product_by_id
    @product_shared = ProductShared.find_by(id: params[:id])
    render json: @product_shared
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

  def get_product_branch
    @products = ProductShared.get_product_branch(branch_id: params[:id])
    @products ? response_to_json("List product", @products, :ok) :
      response_error("something went wrong", :unprocessable_entity)
  end

  private
  def set_product_from_supplier
    params.permit(:name, :image, :quantity_type, :qty, :selling_price, :purchase_price, :expire, :category_id, :name_supplier, :branch_id)
  end

  def set_product
    @product = Product.find_by(id: params[:id])
    response_error("Product not found", :not_found) unless @product.present?
  end
  def pick_product_parent
    @product_shared = ProductShared.find_by(id: params[:id])
  end
  def set_branch_env
    @branch = Branch.find_by(id: params[:id])
  end
end
