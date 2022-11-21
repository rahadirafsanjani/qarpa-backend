class Api::V1::CategoriesController < ApplicationController
  before_action :authorize

  def index
    @categories = Category.get_categories
    response_to_json("List categories", @categories, :ok)
  end

  def create 
    @category = Category.new(category_params)
    @category.save ? response_to_json("New category created", @category, :created) : 
                     response_error(@category.errors, :unprocessable_entity)
  end

  private 

  def category_params 
    params.require(:category).permit(:name)
  end
end
