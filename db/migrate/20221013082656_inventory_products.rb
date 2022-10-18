class InventoryProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :inventory_products do |t|

      t.timestamps
    end
  end
end
