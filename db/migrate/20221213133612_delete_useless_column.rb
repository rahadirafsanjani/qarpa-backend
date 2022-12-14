class DeleteUselessColumn < ActiveRecord::Migration[7.0]
  def change
    remove_column :products_branches, :expire
    remove_column :shippings, :branch_id
    remove_column :shippings, :status
  end
end
