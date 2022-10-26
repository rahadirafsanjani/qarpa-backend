class RemoveUserIdInOrdersAddToPos < ActiveRecord::Migration[7.0]
  def change
    remove_reference :orders, :user, index: true
    add_reference :pos, :user, index: true
  end
end
