class AddNewFieldToSupplier < ActiveRecord::Migration[7.0]
  def change
    add_reference :suppliers, :address, index: true
    add_column :suppliers, :phone, :string 
    add_column :suppliers, :email, :string
  end
end
