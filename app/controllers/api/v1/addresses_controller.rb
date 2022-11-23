class Api::V1::AddressesController < ApplicationController
  before_action :authorize
  before_action :pick_address

  def index
    @address = Address.all
    render json: @address
  end
  def show_by_id
    render json: @address
  end

  private
  def pick_address
    @address = Address.find_by(id: params[:id])
  end
end