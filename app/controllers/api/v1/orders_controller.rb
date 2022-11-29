class Api::V1::OrdersController < ApplicationController
  # before_action :authorize, :check_user_permission, :search_the_branch, :check_branch_status
  before_action :authorize
    
  def create 
    @order = Order.new(order_params)
    @order.save ? response_to_json("New order has been created", :created) : response_to_json(@order.errors, :unprocessable_entity) 
  end

  private 

  def response_to_json(message, status)
    render json: { message: message }, status: status
  end

  def order_params 
    params.require(:order).permit(:customer_id, :payment, :pos_id, :discount, items:[:product_shared_id, :qty])
  end
end
