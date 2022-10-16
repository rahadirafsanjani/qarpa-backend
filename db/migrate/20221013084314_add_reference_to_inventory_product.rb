class AddReferenceToInventoryProduct < ActiveRecord::Migration[7.0]
  def change
    add_reference :inventory_products, :inventory, index: true
    add_reference :inventory_products, :product, index: true
  end
end
