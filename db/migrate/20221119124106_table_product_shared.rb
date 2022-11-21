class TableProductShared < ActiveRecord::Migration[7.0]
  def change
    create_table :product_shareds do |t|
      t.integer :qty
      t.integer :price

      t.timestamps
    end
    add_reference :product_shareds, :product
    add_reference :product_shareds, :supplier
    add_reference :product_shareds, :parent, polymorphic: true, null: true
  end
end
