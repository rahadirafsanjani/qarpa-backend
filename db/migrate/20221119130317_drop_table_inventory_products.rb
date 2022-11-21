class DropTableInventoryProducts < ActiveRecord::Migration[7.0]
  def change
    remove_reference :inventory_products, :inventory, index: true
    remove_reference :inventory_products, :product, index: true
    drop_table :inventory_products do |t|
      t.timestamps null: false
    end
  end
end
