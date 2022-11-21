class ChangeItemShippingProductRelation < ActiveRecord::Migration[7.0]
  def change
    remove_reference :item_shippings, :product, index: true 
    add_reference :item_shippings, :product_shared, index: true
  end
end
