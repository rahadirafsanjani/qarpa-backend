class AddRelationBranchToUser < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :branch, index: true
  end
end
