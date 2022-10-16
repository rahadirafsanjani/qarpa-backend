class AddReferenceToInventory < ActiveRecord::Migration[7.0]
  def change
    add_reference :inventories, :company, index: true
    add_reference :inventories, :address, index: true
  end
end
