class ChangeRelationProductReport < ActiveRecord::Migration[7.0]
  def change
    remove_reference :companies, :product_report
    add_reference :product_reports, :company
  end
end
