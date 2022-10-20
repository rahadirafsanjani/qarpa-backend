class AddRelationToDetailOrderTable < ActiveRecord::Migration[7.0]
  def change
    add_reference :detail_orders, :order, index: true 
    add_reference :detail_orders, :product, index: true
  end
end
