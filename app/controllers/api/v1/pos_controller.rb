class Api::V1::PosController < ApplicationController
  before_action :authorize 

  def open 
    @pos = Pos.new(pos_params)
    @pos.save ? response_to_json(@pos, :created) : 
                response_error(@pos.errors, :unprocessable_entity)
  end

  private 

  def response_to_json(message, status) 
    render json: message, status: status
  end

  def response_error(message, status) 
    render json: { message: message }, status: status
  end

  def pos_params 
    params.require(:pos).permit(:fund, :notes, :open_at, :close_at, :branch_id) 
  end
end
