class Api::V1::ShippingsController < ApplicationController
  before_action :authorize, :current_company

  def create
    @shipping = Shipping.new(shipping_params.merge(assign_at: Time.now.utc).merge(status: 1))
    @shipping.save ? response_to_json("succes", @shipping, :ok) : response_error(@shipping.errors, :unprocessable_entity)
  end

  def delivered_success
    @shipping = Shipping.find_by(id: params[:id])
    @shipping.update(status: 2) ? response_to_json("success", @shipping, :ok) : response_error(@shipping.errors, :unprocessable_entity)
  end

  def show
    @shipping = Shipping.all
    response_to_json("success", @shipping, :ok)
  end

  private

  def shipping_params
    params.require(:shipping).permit( :customer_id, :branch_id, :destination_id, :origin_id, items:[:product_id, :quantity])
  end

  def current_company
    @company = Company.find_by(id: @user.company_id)
  end
end