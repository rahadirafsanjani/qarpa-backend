class Api::V1::ProductsController < ApplicationController
  before_action :authorize
  before_action :set_inventory_env, :new_product_from_supplier, only: %i[ new_product ]
  before_action :set_branch_env, :set_inventory_env, only: %i[  add_product_ready_to_sell show_product_on_branch edit_product_on_branch ]
  before_action :pick_product, only: %i[ update_product edit_product_on_branch delete_product show_product ]
  before_action :set_inventory_env, :set_branch_env, only: %i[ accepted_branch_product  ]

  def new_product
    # @product = @inventory.products.new(set_product.merge(supplier_id: @supplier.id))
    @product = Product.new(set_product.merge(supplier_id: @supplier.id).merge(parent: Inventory.find_by(company_id: @user.company_id)))
    if @product.save
      response_to_json("Product created", @product.new_response, :ok)
    else
      response_error(@product.errors, :unprocessable_entity)
    end
  end

  def show_product
    response_to_json("Product found", @product.product_attribute, :ok)
  end

  def accepted_branch_product
    @products = Product.insert_product_delivered(id: params[:id])
    response_to_json("List product", @products, :ok)
  end

  def delete_product
    @product = Product.find_by(id: params[:id])
    if @product.destroy
      render json: { message: "product was deleted succesfuly" }
    else
      response_error("product cant be delete to, maybe there was problem", :unprocessable_entity)
    end
  end

  def update_product
    if @product.update(set_product)
      response_to_json("Product created", @product.new_response, :ok)
    else
      response_error("product cant be update to, maybe there was problem", :unprocessable_entity)
    end
  end

  def get_all_products
    @product = Product.get_all_products(parent_type: "Inventory")
    response_to_json("success", @product, :ok)
  end

  # only for branch
  def add_product_ready_to_sell
    # @product = @branch.products.new(set_product)
    @product = Product.new(set_product.merge(parent: Branch.find_by(id: params[:id])))
    if @product.save
      response_to_json("succes", @product, :ok)
    end
  end

  def show_product_on_branch
    @product = Product.where(parent: params[:id])
                      .where(parent_type: "Branch")
                      .get_all_products
    response_to_json("success", @product, :ok)
  end

  def edit_product_on_branch
    if @product.update(set_product)
      response_to_json("success", @product, :ok)
    end
  end

  private

  def pick_product
    @product = Product.find_by(id: params[:id])
    response_error("Product not found", :not_found) unless @product.present?
  end

  def set_product
    params.permit(:name, :quantity, :quantity_type, :category, :expire, :price, :image)
  end

  def new_product_from_supplier
    @supplier = Supplier.find_or_create_by(name: params[:name_supplier])
  end

  def set_inventory_env
    @inventory = Inventory.find_by(company_id: @user.company_id)
  end

  def set_branch_env
    @branch = Branch.find_by(id: params[:id])
  end
end
