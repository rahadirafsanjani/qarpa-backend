class AddUserColumnTokenRegist < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :regist_token, :string
    add_column :users, :regist_token_sent_at, :datetime
  end
end
