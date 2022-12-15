class Api::V1::ProductsController < ApplicationController
  before_action :authorize
  before_action :user_permission, only: %i[ delete_product ]

  def new_product
    @product = Product.find_by(name: params[:name])
    if @product.blank?
      @create = Product.new(set_product_from_supplier)
      if @create.save
        response_to_json( "success", @create, :ok)
      else
        response_error(@create.errors, :unprocessable_entity)
      end
    elsif @product.present?
      @product = Product.find_by(name: params[:name], category_id: params[:category_id])
      @products_branch = ProductsBranch.create_product_branch(new_qty: params[:qty], supplier_id: params[:supplier_id],
                                                             name: params[:name], branch_id: params[:branch_id], product_id: @product.id,
                                                             selling_price: params[:selling_price],
                                                              # little bit stupid but its hafiz says
                                                              purchase_price: params[:selling_price])
      response_to_json("success", @products_branch, :ok)
    else
      render json: "something went wrong"
    end
  end

  def index
    @products = ProductsBranch.get_index
    response_to_json("success", @products, :ok)
  end

  def show_product_by_id
    @product_shareds = ProductsBranch.find_by(id: params[:id])
    @product_shareds.present? ? response_to_json("Product found", @product_shareds.new_product_attribute, :ok) : 
                              response_error("Product not found", :not_found)
  end

  def get_product_branch
    @products = ProductsBranch.get_products_branch(branch_id: params[:id])
    response_to_json("List products", @products, :ok)
  end

  def update_product
    @find_product = ProductsBranch.find_by(id: params[:id])
    @product_shared = ProductsBranch.update_product(name: params[:name],
                                   qty: params[:qty],
                                   category_id: params[:category_id],
                                   selling_price: params[:selling_price],
                                   image: params[:image],
                                   branch_id: params[:branch_id], products_branch_id: @find_product.id)
    response_to_json("success", @product_shared, :ok)
  end

  def delete_product
    @product = ProductsBranch.find_by(id: params[:id])
    @product.present? ? response_to_json("Product has been deleted", @product.destroy, :ok) :
                        response_error("Product not found", :not_found)
  end
  
  def unit_dropdown
    @units = Product.units
    response_to_json("Dropdown units", @units, :ok)
  end

  def condition_dropdown 
    @conditions = Product.condition_products
    response_to_json("Dropdown conditions product", @conditions, :ok)
  end

  private
  
  def set_product_from_supplier
    params.permit(:name, :image, :quantity_type, :qty, :selling_price, :purchase_price, :category_id, :supplier_id, :branch_id)
  end
end
