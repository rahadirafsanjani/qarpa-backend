class CreateItemShippings < ActiveRecord::Migration[7.0]
  def change
    create_table :item_shippings do |t|
      t.integer :quantity

      t.timestamps
    end
  end
end
