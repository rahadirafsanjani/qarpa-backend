class CreatePos < ActiveRecord::Migration[7.0]
  def change
    create_table :pos do |t|
      t.boolean :status      
      t.integer :fund
      t.string :notes
      t.datetime :open_at 
      t.datetime :close_at

      t.timestamps
    end
  end
end
