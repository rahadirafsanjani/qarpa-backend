class CreateSessions < ActiveRecord::Migration[7.0]
  def change
    create_table :sessions do |t|
      t.string :token

      t.timestamps
    end
    add_reference :sessions, :user, index: true
  end
end
