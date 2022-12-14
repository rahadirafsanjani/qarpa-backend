class AddRelationToProductR < ActiveRecord::Migration[7.0]
  def change
    add_reference :product_reports, :branch, index: true
  end
end
