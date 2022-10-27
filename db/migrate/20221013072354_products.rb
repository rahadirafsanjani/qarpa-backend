class Products < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name
      t.integer :quantity
      t.string :quantity_type
      t.string :category
      t.datetime :expire
      t.integer :price

      t.timestamps
    end
  end
end
