class Api::V1::SuppliersController < ApplicationController
  before_action :authorize
  before_action :set_supplier, only: %i[ update destroy ]

  def create 
    @supplier = Supplier.new(supplier_params)
    @supplier.save ? response_to_json("New supplier has been created", @supplier.supplier_attribute, :created) : 
                     response_error(@supplier.errors, :unprocessable_entity)
  end

  def update 
    @supplier.update(supplier_params) ? response_to_json("Supplier has been updated", @supplier.supplier_attribute, :ok) :
                                        response_error(@supplier.errors, :unprocessable_entity)
  end

  def destroy 
    @supplier.destroy ? response_to_json("Supplier has been deleted", @supplier.supplier_attribute, :ok) : 
                        response_error("Something went wrong", :bad_request)
  end

  def dropdown
    @suppliers = Supplier.dropdown(company_id: @user.company_id)
    response_to_json("Suppliers dropdown", @suppliers, :ok)
  end

  private 

  def set_supplier 
    @supplier = Supplier.find_by(id: params[:id])
    response_error("Supplier not found", :not_found) unless @supplier.present?
  end

  def supplier_params 
    params.require(:supplier).permit(:name, :full_address, :phone, :email).merge(company_id: @user.company_id)
  end
end
