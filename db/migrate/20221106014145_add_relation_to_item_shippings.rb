class AddRelationToItemShippings < ActiveRecord::Migration[7.0]
  def change
    add_reference :item_shippings, :product
    add_reference :item_shippings, :shipping
  end
end
