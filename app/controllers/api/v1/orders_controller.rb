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

  # def check_user_permission 
  #   response_to_json("You don't have permission to create new order", :forbidden) unless @user.branch.present? && @user.branch.id == order_params[:branch_id]
  # end

  # def check_branch_status
  #   response_to_json("Please open the branch before do some order", :bad_request) unless @branch.status
  # end

  # def search_the_branch
  #   @branch = Branch.find_by(id: order_params[:branch_id])
  #   response_to_json("Branch not found", :not_found) unless @branch.present?
  # end

  def order_params 
    params.require(:order).permit(:customer_id, :payment_method, :pos_id, :discount, item:[:product_id, :qty])
  end
end
