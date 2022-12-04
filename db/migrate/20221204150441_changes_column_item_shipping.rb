class ChangesColumnItemShipping < ActiveRecord::Migration[7.0]
  def change
    rename_column :item_shippings, :quantity, :qty
  end
end
