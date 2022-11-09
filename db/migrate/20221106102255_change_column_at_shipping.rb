class ChangeColumnAtShipping < ActiveRecord::Migration[7.0]
  def change
    change_column :shippings, :status, :integer, using: 'status::integer'
  end
end
