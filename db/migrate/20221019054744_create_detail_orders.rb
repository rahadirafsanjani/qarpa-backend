class CreateDetailOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :detail_orders do |t|
      t.integer :qty

      t.timestamps
    end
  end
end
