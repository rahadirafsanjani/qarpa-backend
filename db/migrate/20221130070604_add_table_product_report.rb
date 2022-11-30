class AddTableProductReport < ActiveRecord::Migration[7.0]
  def change
    create_table :product_reports do |t|
      t.string :name
      t.integer :purchase_price
      t.integer :qty

      t.timestamps
    end
    add_reference :companies, :product_report
  end
end
