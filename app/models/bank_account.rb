class BankAccount < ApplicationRecord
  belongs_to :company

  validates :username, :bank, :account_number, presence: true
  validates :account_number, numericality: { only_integer: true }

  def self.get_all_bank_accounts params = {}
    bank_accounts = BankAccount.where(params)
    bank_accounts.map do |bank_account|
      bank_account.new_response
    end
  end

  def new_response
    {
      "id": self.id,
      "username": self.username,
      "bank": self.bank,
      "account_number": self.account_number,
      "company_id": self.company_id
    }
  end
end
