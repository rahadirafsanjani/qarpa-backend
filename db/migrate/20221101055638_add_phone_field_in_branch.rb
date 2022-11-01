class AddPhoneFieldInBranch < ActiveRecord::Migration[7.0]
  def change
    add_column :branches, :phone, :string
  end
end
