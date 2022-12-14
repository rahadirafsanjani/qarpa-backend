class RenameProductsBranchesId < ActiveRecord::Migration[7.0]
  def change
    rename_column :products_quantities, :products_branches_id, :products_branch_id
    #Ex:- rename_column("admin_users", "pasword","hashed_pasword")
  end
end
