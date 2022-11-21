class ChangeProductRelation < ActiveRecord::Migration[7.0]
  def change
    remove_reference :detail_orders, :product, index: true
    add_reference :detail_orders, :product_shared, index: true
  end
end
