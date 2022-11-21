class Category < ApplicationRecord
  has_many :products

  def self.get_categories 
    @categories = Category.all 
    @categories.map do |category|
      {
        "id": category.id,
        "value": category.name
      }
    end
  end
end