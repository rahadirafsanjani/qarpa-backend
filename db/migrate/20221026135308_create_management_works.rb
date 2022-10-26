class CreateManagementWorks < ActiveRecord::Migration[7.0]
  def change
    create_table :management_works do |t|
      t.string :task
      t.text :description
      t.date :start_at
      t.date :end_at
      t.integer :status, :default => 0
      t.belongs_to :user, index:true

      t.timestamps
    end
  end
end
