class ChangesColumn < ActiveRecord::Migration[7.0]
  def change
    remove_column :products, :category
    remove_column :products, :price
    remove_column :products, :quantity
    remove_column :products, :expire
  end
end
