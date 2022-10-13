class CreateBranches < ActiveRecord::Migration[7.0]
  def change
    create_table :branches do |t|
      t.string :name
      t.datetime :open_at
      t.datetime :close_at
      t.boolean :status
      t.integer :fund
      t.string :notes

      t.timestamps
    end
  end
end
