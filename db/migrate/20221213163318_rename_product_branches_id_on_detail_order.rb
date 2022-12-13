class RenameProductBranchesIdOnDetailOrder < ActiveRecord::Migration[7.0]
  def change
    rename_column :detail_orders, :products_branches_id, :products_branch_id
    #Ex:- rename_column("admin_users", "pasword","hashed_pasword")
  end
end
