class Api::V1::CustomersController < ApplicationController
  before_action :authorize
  before_action :set_customer, only: %i[ update destroy ]

  def create 
    @customer = Customer.new(customer_params)
    
    @customer.save ? response_to_json(@customer, :created) : 
                     response_error(@customer.errors, :unprocessable_entity)
  end

  def update 
    @customer.update(customer_params) ? response_to_json(@customer, :ok) :
                                        response_error(@customer.errors, :unprocessable_entity) 
  end

  def destroy
    @customer.destroy ? response_to_json(@customer, :ok) :
                        response_error("Something went wrong", :unprocessable_entity)
  end

  private 

  def response_to_json(message, status)
    render json: message, status: status
  end

  def response_error(message, status)
    render json: { message: message }, status: status
  end

  def set_customer 
    @customer = Customer.find_by(id: params[:id])
    response_error("Customer not found", :not_found) unless @customer.present? 
    end
  end

  def customer_params 
    params.require(:customer).permit(:name, :phone, :full_address, :postal_code).merge(company_id: @user.company_id) 
  end
end
