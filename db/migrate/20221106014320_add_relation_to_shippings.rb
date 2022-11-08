class AddRelationToShippings < ActiveRecord::Migration[7.0]
  def change
    add_reference :shippings, :customer
    add_reference :shippings, :branch
  end
end
