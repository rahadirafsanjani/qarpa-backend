class Address < ApplicationRecord
  validates :full_address, :postal_code, presence: true
  validates :postal_code, numericality: { only_integer: true }
end
