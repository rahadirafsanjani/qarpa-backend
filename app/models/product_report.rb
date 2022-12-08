class ProductReport < ApplicationRecord
  belongs_to :company
  belongs_to :supplier
end