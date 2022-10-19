class Api::V1::OrdersController < ApplicationController
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
    params.require(:order).permit(:customer_id, :payment_method, item:[:product_id, :qty]).merge(user_id: @user.id, branch_id: @user.branch.id)
  end
end
