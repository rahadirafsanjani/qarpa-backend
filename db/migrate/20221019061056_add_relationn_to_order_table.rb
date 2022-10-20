class AddRelationnToOrderTable < ActiveRecord::Migration[7.0]
  def change
    add_reference :orders, :branch, index: true
    add_reference :orders, :user, index: true 
    add_reference :orders, :customer, index: true 
  end
end
