class RemovePostalCodeInAddress < ActiveRecord::Migration[7.0]
  def change
    remove_column :addresses, :postal_code
  end
end
