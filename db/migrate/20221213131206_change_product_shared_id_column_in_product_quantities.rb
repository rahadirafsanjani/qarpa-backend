class ChangeProductSharedIdColumnInProductQuantities < ActiveRecord::Migration[7.0]
  def change
    rename_column :products_quantities, :product_shareds_id, :product_shared_id 
  end
end
