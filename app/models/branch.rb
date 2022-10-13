class Branch < ApplicationRecord
  validates :name, :fund, :notes, presence: true
  validates :fund, numericality: { only_integer: true }
end
