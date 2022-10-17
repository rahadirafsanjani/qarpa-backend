class AddRelationAddressToCustomers < ActiveRecord::Migration[7.0]
  def change
    add_reference :customers, :address, index: true
  end
end
