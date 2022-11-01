class Attendance < ActiveRecord::Migration[7.0]
  def change
    create_table :attendances do |t|
      t.decimal :latitude
      t.decimal :longitude
      t.datetime :check_in
      t.datetime :check_out
      t.boolean :status, default: false

      t.timestamps
    end
  end
end
