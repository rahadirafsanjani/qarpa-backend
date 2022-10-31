class RemovePaymentMethodFromOrder < ActiveRecord::Migration[7.0]
  def change
    remove_column :orders, :payment_method
  end
end
