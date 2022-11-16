class ChangesColumnRelation < ActiveRecord::Migration[7.0]
  def change
    change_column :shippings, :branch_id, :int, null: true
    change_column :shippings, :customer_id, :int, null: true
  end
end
