class ChangeRemovePolymorbics < ActiveRecord::Migration[7.0]
  def change
    add_reference :product_shareds, :branch, index: true
    remove_reference :product_shareds, :parent, polymorphic: true, null: true
  end
end
