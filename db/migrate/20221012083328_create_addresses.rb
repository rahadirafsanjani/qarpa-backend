class CreateAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :addresses do |t|
      t.string :full_address
      t.string :postal_code, limit: 5

      t.timestamps
    end
  end
end
