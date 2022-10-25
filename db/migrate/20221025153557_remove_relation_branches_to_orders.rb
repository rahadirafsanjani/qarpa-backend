class RemoveRelationBranchesToOrders < ActiveRecord::Migration[7.0]
  def change
    remove_reference :orders, :branch, index: true
  end
end
