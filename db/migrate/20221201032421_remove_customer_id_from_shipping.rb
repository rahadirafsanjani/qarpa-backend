class RemoveCustomerIdFromShipping < ActiveRecord::Migration[7.0]
  def change
    remove_reference :, :branch, index: true
  end
end
