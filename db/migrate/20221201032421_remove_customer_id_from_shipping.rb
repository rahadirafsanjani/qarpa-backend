class RemoveCustomerIdFromShipping < ActiveRecord::Migration[7.0]
  def change
    remove_reference :shippings, :customer, index: true
  end
end
