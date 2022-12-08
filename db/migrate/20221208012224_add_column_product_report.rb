class AddColumnProductReport < ActiveRecord::Migration[7.0]
  def change
    add_reference :product_reports, :supplier, index: true
  end
end
