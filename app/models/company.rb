class Company < ApplicationRecord
  has_many :users
  has_many :customers
  has_many :branches
  has_many :bank_accounts
  has_many :product_reports
end
