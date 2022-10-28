class CreateLeaveManagements < ActiveRecord::Migration[7.0]
  def change
    create_table :leave_managements do |t|
      t.string :title
      t.string :notes
      t.date :start_at
      t.date :end_at
      t.integer :status, :default => 0
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
