class ChangeAddColumnInProductShared < ActiveRecord::Migration[7.0]
  def change
    add_column :product_shareds, :purchase_price, :integer
    rename_column :product_shareds, :price, :selling_price
  end
end
