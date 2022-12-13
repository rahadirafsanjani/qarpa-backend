class DropTableProductReports < ActiveRecord::Migration[7.0]
  def change
    drop_table :product_reports
  end
end
