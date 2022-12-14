class RenameTableProductShared < ActiveRecord::Migration[7.0]
  def change
    rename_table :product_shareds, :products_branches
  end
end
