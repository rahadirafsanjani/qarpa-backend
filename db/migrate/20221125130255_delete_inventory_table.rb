class DeleteInventoryTable < ActiveRecord::Migration[7.0]
  def change
    remove_reference :inventories, :address, index: true
    remove_reference :inventories, :company, index: true
    drop_table :inventories do |t|
      t.timestamps null: false
    end
  end
end
