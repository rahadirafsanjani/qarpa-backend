class AddBranchToShipping < ActiveRecord::Migration[7.0]
  def change
    add_reference :shippings, :origin, foreign_key: { to_table: :branches }
    add_reference :shippings, :destination, foreign_key: { to_table: :branches }
  end
end
