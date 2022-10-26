class ChangeBranchAndPosField < ActiveRecord::Migration[7.0]
  def change
    remove_column :pos, :status
    add_column :branches, :status, :boolean
  end
end
