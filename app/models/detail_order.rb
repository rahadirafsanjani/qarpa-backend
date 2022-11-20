class DetailOrder < ApplicationRecord
  belongs_to :order 
  belongs_to :product_shared 

  validates :qty, presence: true 
  validates :qty, numericality: { only_integer: true }
end
