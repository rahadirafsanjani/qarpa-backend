class AddRelationToAttendance < ActiveRecord::Migration[7.0]
  def change
    add_reference :attendances, :user
  end
end
