class ChangeColumnTypeInProductQuantity < ActiveRecord::Migration[7.0]
  def change
    rename_column :products_quantities, :type, :qty_type
  end
end
