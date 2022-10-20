class Api::V1::ProductsController < ApplicationController
  before_action :pick_product, only: %i[ update_product delete_product ]
  def new_product
    @product = Product.new(set_product)
    if @product.save
      render json: { message: "product was created" }
    else
      render json: { message: "product cant be add to, maybe there was problem" }
    end
  end

  def delete_product
    product = Product.find_by(id: params[:id])
    if product.destroy
      render json: { message: "product was deleted succesfuly" }
    else
      render json: { message: "something err" }
    end
  end

  def update_product
    if @product.update(set_product)
      render json: { message: "product was updated" }
    else
      render json: { message: "there some err" }, status: :unprocessable_entity
    end
  end

  def new_product_from_supplier
    @supplier = Supplier.find_or_create_by(name: params[:name_supplier])
    if Product.create(set_product.merge(supplier_id: @supplier.id))
      render json: { message: "product was accepted" }
    else
      render json: { message: "there some err" }
    end
  end

  def show_suplai
    @product = Product.all.where(category: "suplai")
    render json: { message: @product }
  end

  def show_stock
    @product = Product.all.where(category: "stock")
    render json: { message: @product }
  end

  private
  def pick_product
    @product = Product.find_by(id: set_product[:id])
  end
  def set_product
    params.require(:product).permit(:id, :name, :quantity, :quantity_type, :category, :expire, :image, :price)
  end
end