class AddRelationBankAccountToCompany < ActiveRecord::Migration[7.0]
  def change
    add_reference :bank_accounts, :company, index: true
  end
end
