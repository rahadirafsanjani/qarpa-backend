class RenameReferencePb < ActiveRecord::Migration[7.0]
  def change
    rename_column :products_quantities, :product_shareds_id, :products_branches_id
    rename_column :item_shippings, :product_shared_id, :products_branches_id
    rename_column :detail_orders, :product_shared_id, :products_branches_id
  end
end
