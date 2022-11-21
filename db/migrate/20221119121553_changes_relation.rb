class ChangesRelation < ActiveRecord::Migration[7.0]
  def change
    remove_reference :products, :inventory, index: true
    remove_reference :products, :parent, polymorphic: true, null: true
  end
end
