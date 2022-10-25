class AddReferenceBranchesToPos < ActiveRecord::Migration[7.0]
  def change
    add_reference :pos, :branch, index: true
  end
end
