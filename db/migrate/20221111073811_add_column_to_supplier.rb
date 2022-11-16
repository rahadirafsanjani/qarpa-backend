class AddColumnToSupplier < ActiveRecord::Migration[7.0]
  def change
    add_reference :suppliers, :company
  end
end
