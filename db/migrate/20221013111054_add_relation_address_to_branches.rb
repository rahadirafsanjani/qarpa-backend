class AddRelationAddressToBranches < ActiveRecord::Migration[7.0]
  def change
    add_reference :branches, :address, index: true
  end
end
