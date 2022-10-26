class AddCompanyRelationToMagagementWork < ActiveRecord::Migration[7.0]
  def change
    add_reference :management_works, :company
  end
end
