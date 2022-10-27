class AddCompanyIdToCustomerTable < ActiveRecord::Migration[7.0]
  def change
    add_reference :customers, :company, index: true
  end
end
