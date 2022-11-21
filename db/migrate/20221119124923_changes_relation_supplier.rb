class ChangesRelationSupplier < ActiveRecord::Migration[7.0]
  def change
    remove_reference :products, :supplier, index: true
  end
end
