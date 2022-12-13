class DropColumnQtyOnProductShared < ActiveRecord::Migration[7.0]
  def change
    remove_column :product_shareds, :qty
  end
end
