class EditStatusOnShipping < ActiveRecord::Migration[7.0]
  def change
    change_column(:shippings, :status, :integer, default: 0)
  end
end
