class DeleteRelationShipping < ActiveRecord::Migration[7.0]
  def change
    remove_reference :shippings, :origin, index: true
    remove_reference :shippings, :destination, index: true
  end
end
