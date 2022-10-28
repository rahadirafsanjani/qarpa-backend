class RenameStatusToLeaveStatusInLeaveManagemen < ActiveRecord::Migration[7.0]
  def change
    rename_column :leave_managements, :status, :leave_status 
  end
end
