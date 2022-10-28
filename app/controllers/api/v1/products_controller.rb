class Api::V1::ProductsController < ApplicationController
  before_action :authorize
  before_action :new_product_from_supplier, only: %i[ new_product ]
  before_action :pick_product, only: %i[ update_product delete_product ]

  def new_product
    @inventory = Inventory.find_by(company_id: @user.company_id)
    @product = Product.new(set_product.merge(supplier_id: @supplier.id)
                                      .merge(inventory_id: @inventory.id))
    if @product.save
      render json: get_specific_data
    else
      render json: { message: "product cant be add to, maybe there was problem" }
    end
  end

  def delete_product
    @product = Product.find_by(id: params[:id])
    if @product.destroy
      render json: { message: "product was deleted succesfuly" }
    else
      render json: { message: "something err" }
    end
  end

  def update_product
    if @product.update(set_product)
      render json: get_specific_data
    else
      render json: { message: "there some err" }, status: :unprocessable_entity
    end
  end

  def show_suplai
    @product = Product.where(category: "suplai")
                      .where(inventory_id: set_company_env)
    render json: get_all_data
  end

  def show_stock
    @product = Product.where(category: "stock")
                      .where(inventory_id: set_company_env)

    render json: get_all_data
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
  def get_all_data
    CatalogProductSerializer.new(@product).serializable_hash[:data]
  end
  def get_specific_data
    NewProductSerializer.new(@product).serializable_hash[:data][:attributes]
  end
  def set_company_env
    Inventory.find_by(company_id: @user.company_id)
  end
end
