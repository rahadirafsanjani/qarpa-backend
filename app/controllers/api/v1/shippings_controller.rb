class Api::V1::ShippingsController < ApplicationController
  before_action :authorize

  def create
    @shipping = Shipping.new(shipping_params)
    @shipping.save ? response_to_json("succes", @shipping, :ok) : response_error(@shipping.errors, :unprocessable_entity)
  end

  private

  def shipping_params
    params.require(:shipping).permit( :customer_id, :branch_id, :destination_id, :status, :origin_id, items:[:product_id, :quantity])
  end
end