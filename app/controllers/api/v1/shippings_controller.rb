class Api::V1::ShippingsController < ApplicationController
  before_action :authorize
  before_action :current_company

  def create
    @shipping = Shipping.new(shipping_params.merge(assign_at: Time.now))
    @shipping.save ? response_to_json("succes", @shipping, :ok) : response_error(@shipping.errors, :unprocessable_entity)
  end

  def show
    @shipping = Shipping.all
    response_to_json("success", @shipping, :ok)
  end

  def history_all
    @history = Shipping.shipping_history
    response_to_json("Success", @history, :ok)
  end

  def history_branch
    @history = Shipping.shipping_history_branch(branch_id: @user.branch_id)
    response_to_json("Success", @history, :ok)
  end

  private
  def shipping_params
    params.permit(:destination_id, :origin_id, items:[:products_branch_id, :qty])
  end

  def current_company
    @company = Company.find_by(id: @user.company_id)
  end
end