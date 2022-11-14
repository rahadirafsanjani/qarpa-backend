class Api::V1::ProductsController < ApplicationController
  # include ActiveStorage::SetCurrent
  before_action :authorize
  before_action :new_product_from_supplier, :set_inventory_env, :set_branch_env, only: %i[ new_product accepted_branch_product  ]
  before_action :pick_product, only: %i[ update_product delete_product ]

  def new_product
    @product = @inventory.products.new(set_product.merge(supplier_id: @supplier.id)
                                                  .merge(inventory_id: @inventory.id))
    if @product.save
      response_to_json("Product created", @product.new_response, :ok)
    else
      response_error(@product.errors, :unprocessable_entity)
    end
  end

  def accepted_branch_product
    @shipping = Shipping.where(status: 2)
    @convert_product = ItemShipping.where(shipping_id: params[:id])
    @convert_product.map do | convert |
      @product = Product.find_by(id: convert.product_id)
      converted = @branch.products.new(@product)
      if converted.save && converted.update(quantity: convert.quantity)
        render json: converted
      end
    end
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

  def show_suplai
    @product = Product.where(inventory_id: set_company_env.id)
                      .get_all_products
    response_to_json("success", @product, :ok)
  end

  private
  def pick_product
    @product = Product.find_by(id: params[:id])
  end
  def set_product
    params.permit(:id, :name, :quantity, :quantity_type, :category, :expire, :price, :image)
  end
  def new_product_from_supplier
    @supplier = Supplier.find_or_create_by(name: params[:name_supplier])
  end
  def set_company_env
    Inventory.find_by(company_id: @user.company_id)
  end
  def set_inventory_env
    @inventory = Inventory.find_by(company_id: @user.company_id)
  end
  def set_branch_env
    @branch = Branch.find_by(id: params[:branch_id])
  end

  def get_item_shipping
    @item_shipping = ItemShipping.find_by(:id )
  end
end
