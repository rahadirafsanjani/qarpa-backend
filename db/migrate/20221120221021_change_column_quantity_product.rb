class ChangeColumnQuantityProduct < ActiveRecord::Migration[7.0]
  def change
    rename_column :product_shareds, :quantity, :qty
  end
end
