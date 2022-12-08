class Api::V1::ShippingsController < ApplicationController
  before_action :authorize
  before_action :current_company

  def create
    @shipping = Shipping.new(shipping_params.merge(assign_at: Time.now).merge(status: 1))
    @shipping.save ? response_to_json("succes", @shipping, :ok) : response_error(@shipping.errors, :unprocessable_entity)
  end

  def show
    @shipping = Shipping.all
    response_to_json("success", @shipping, :ok)
  end

  def history
    @history = Shipping.shipping_history
    render json: @history
  end

  private
  def shipping_params
    params.permit(:destination_id, :origin_id, items:[:product_shared_id, :qty])
  end

  def current_company
    @company = Company.find_by(id: @user.company_id)
  end
end