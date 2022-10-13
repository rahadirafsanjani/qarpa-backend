class AddRelationBranchToCompany < ActiveRecord::Migration[7.0]
  def change
    add_reference :branches, :company, index: true
  end
end
