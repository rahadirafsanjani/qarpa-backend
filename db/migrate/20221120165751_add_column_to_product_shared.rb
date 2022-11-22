class AddColumnToProductShared < ActiveRecord::Migration[7.0]
  def change
    add_column :product_shareds, :expire, :date
    rename_column :product_shareds, :qty, :quantity
  end
end
