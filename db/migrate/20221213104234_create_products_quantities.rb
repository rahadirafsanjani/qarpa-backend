class CreateProductsQuantities < ActiveRecord::Migration[7.0]
  def change
    create_table :products_quantities do |t|
      t.integer :qty
      t.integer :type
      t.belongs_to :product_shareds, null: false, foreign_key: true

      t.timestamps
    end
  end
end
