class RemoveColumnInBranches < ActiveRecord::Migration[7.0]
  def change
    remove_column :branches, :open_at
    remove_column :branches, :close_at
    remove_column :branches, :status 
    remove_column :branches, :fund 
    remove_column :branches, :notes
  end
end
