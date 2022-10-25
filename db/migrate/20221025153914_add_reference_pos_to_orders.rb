class AddReferencePosToOrders < ActiveRecord::Migration[7.0]
  def change
    add_reference :orders, :pos, index: true
  end
end
