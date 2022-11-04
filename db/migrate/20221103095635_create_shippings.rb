class CreateShippings < ActiveRecord::Migration[7.0]
  def change
    create_table :shippings do |t|
      t.datetime :assign_at
      t.references :destination, references: :addresses, null: false, foreign_key: {to_table: :addresses}
      t.references :origin, references: :addresses, null: false, foreign_key: {to_table: :addresses}
      t.string :status

      t.timestamps
    end
  end
end
