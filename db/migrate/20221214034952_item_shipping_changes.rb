class ItemShippingChanges < ActiveRecord::Migration[7.0]
  def change
    rename_column :item_shippings, :products_branches_id, :products_branch_id
  end
end
