class Supplier < ActiveRecord::Migration[7.0]
  def change
    create_table :supplier do |t|
      t.string :name

      t.timestamps
    end
  end
end
