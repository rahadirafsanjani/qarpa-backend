class DetailOrder < ApplicationRecord
  belongs_to :order 
  belongs_to :products_branch

  validates :qty, presence: true 
  validates :qty, numericality: { only_integer: true }
end
