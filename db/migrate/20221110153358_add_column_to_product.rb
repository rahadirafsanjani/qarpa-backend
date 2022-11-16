class AddColumnToProduct < ActiveRecord::Migration[7.0]
  def change
    add_reference :products, :parent, polymorphic: true, null: true
  end
end
