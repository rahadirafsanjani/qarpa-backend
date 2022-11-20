class AddPaymentToOrder < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :payment, :integer
  end
end
