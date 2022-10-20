class AddRelationToProduct < ActiveRecord::Migration[7.0]
  def change
    add_reference :products, :supplier, index: true
  end
end
