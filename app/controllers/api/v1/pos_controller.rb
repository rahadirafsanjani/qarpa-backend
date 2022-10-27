class Api::V1::PosController < ApplicationController
  before_action :authorize 
  before_action :set_pos, only: %i[ close ]

  def open 
    @pos = Pos.new(pos_params)
    @pos.save ? response_to_json("New pos has been opened", @pos, :created) : 
                response_error(@pos.errors, :unprocessable_entity)
  end

  def close 
    @pos.close_pos ? response_to_json("Pos has been closed", @pos, :ok) :
                     response_error("Something went wrong", :unprocessable_entity)
  end

  private 

  def response_to_json(message, data, status) 
    render json: { message: message, data: data }, status: status
  end

  def response_error(message, status) 
    render json: { message: message }, status: status
  end

  def set_pos 
    @pos = Pos.find_by(id: params[:id])
    response_error("Pos not found", :not_found) unless @pos.present?  
  end

  def pos_params 
    params.require(:pos).permit(:fund, :notes, :branch_id).merge(user_id: @user.id) 
  end
end