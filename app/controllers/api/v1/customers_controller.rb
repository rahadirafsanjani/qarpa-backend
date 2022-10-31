class Api::V1::CustomersController < ApplicationController
  before_action :authorize
  before_action :set_customer, only: %i[ update destroy ]

  def index 
    @customers = Customer.customer_response(company_id: @user.company_id)
    response_to_json("Customers", @customers, :ok)
  end

  def create 
    @customer = Customer.new(customer_params)
    
    @customer.save ? response_to_json("New customer created", @customer.new_response, :created) : 
                     response_error(@customer.errors, :unprocessable_entity)
  end

  def update 
    @customer.update(customer_params) ? response_to_json("Customer updated", @customer.new_response, :ok) :
                                        response_error(@customer.errors, :unprocessable_entity) 
  end

  def destroy
    @customer.destroy ? response_to_json("Customer deleted", @customer.new_response, :ok) :
                        response_error("Something went wrong", :unprocessable_entity)
  end

  private 

  def response_to_json(message, data, status)
    render json: { message: message, data: data }, status: status
  end

  def response_error(message, status)
    render json: { message: message }, status: status
  end

  def set_customer 
    @customer = Customer.find_by(id: params[:id])
    response_error("Customer not found", :not_found) unless @customer.present? 
  end

  def customer_params 
    params.require(:customer).permit(:name, :phone, :full_address, :postal_code, :email).merge(company_id: @user.company_id) 
  end
end
