class Address < ApplicationRecord
  has_many :branches

  validates :full_address, presence: true
end
