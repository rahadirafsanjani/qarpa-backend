class Api::V1::CategoriesController < ApplicationController
  before_action :authorize

  def index
    @categories = Category.get_categories
    response_to_json("List categories", @categories, :ok)
  end
end
