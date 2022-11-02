class AddDiscountToOrderTable < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :discount, :integer
  end
end
