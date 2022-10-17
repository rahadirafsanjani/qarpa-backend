class Api::V1::CustomersController < ApplicationController
  before_action :authorize
  before_action :set_customer, only: %i[ update destroy ]

  def create 
    @customer = Customer.new(customer_params)
    
    if @customer.save 
      render json: @customer, status: :created 
    else
      render json: @customer.errors, status: :unprocessable_entity
    end
  end

  def update 
    if @customer.update(customer_params)
      render json: @customer, status: :ok 
    else
      render json: @customer.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @customer.destroy

    render json: @customer, status: :ok
  end

  private 

  def set_customer 
    begin
      @customer = Customer.find(params[:id])
    rescue ActiveRecord::RecordNotFound 
      render json: { message: "Customer not found" }, status: :not_found    
    end
  end

  def customer_params 
    params.require(:customer).permit(:name, :phone, :full_address, :postal_code) 
  end
end
