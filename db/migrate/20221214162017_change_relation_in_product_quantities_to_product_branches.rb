class ChangeRelationInProductQuantitiesToProductBranches < ActiveRecord::Migration[7.0]
  def change
    remove_reference :products_quantities, :products_branch, foreign_key: true
    add_reference :products_quantities, :products_branch, index: true, on_delete: :cascade
  end
end
