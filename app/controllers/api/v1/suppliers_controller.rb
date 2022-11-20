class Api::V1::SuppliersController < ApplicationController
  before_action :authorize

  def dropdown
    @suppliers = Supplier.dropdown(company_id: @user.company_id)
    response_to_json("Suppliers dropdown", @suppliers, :ok)
  end
end
