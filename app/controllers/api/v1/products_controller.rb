class Api::V1::ProductsController < ApplicationController
  before_action :authorize

  def new_product
    @product = Product.find_by(name: params[:name])
    if @product.blank?
      @test = Product.new(set_product_from_supplier)
      @test.save
      render json: @test
    elsif @product.present?
      @product = Product.find_by(name: params[:name], category_id: params[:category_id])
      @product_shared = ProductShared.sum_qty(new_qty: params[:qty], supplier_id: params[:supplier_id], name: params[:name], branch_id: params[:branch_id], product_id: @product.id)
      @update_report = ProductShared.add_through_report(name: params[:name], qty: params[:qty], purchase_price: params[:purchase_price], company_id: @user.company_id)
      render json: @product_shared
    else
      render json: "something went wrong"
    end
  end

  def index
    @products = ProductShared.get_index
    response_to_json("success", @products, :ok)
  end

  def show_product_by_id
    @product_shared = ProductShared.get_by_id(id: params[:id])
    response_to_json("success", @product_shared, :ok)
  end

  def get_product_branch
    @products = ProductShared.get_product_branch(branch_id: params[:id])
    @products ? response_to_json("List product", @products, :ok) :
      response_error("something went wrong", :unprocessable_entity)
  end

  def update_product
    @find_product = ProductShared.find_by(id: params[:id])
    @product_shared = ProductShared.update_product(name: params[:name],
                                   qty: params[:qty],
                                   category_id: params[:category_id],
                                   selling_price: params[:selling_price],
                                   image: params[:image],
                                   branch_id: params[:branch_id],
                                   product_shared_id: @find_product.id)
    response_to_json("success", @product_shared, :ok)
  end

  def delete_product
    if @user.role.downcase == "owner"
      @product = ProductShared.find_by(id: params[:id])
      @product.delete
      response_to_json("success", @product, :ok)
    end
  end

  private
  def set_product_from_supplier
    params.permit(:name, :image, :quantity_type, :qty, :selling_price, :purchase_price, :expire, :category_id, :supplier_id, :branch_id)
  end
end
