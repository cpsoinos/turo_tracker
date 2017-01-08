class AddExpensedToTrips < ActiveRecord::Migration[5.0]
  def change
    add_column :trips, :expensed, :boolean
  end
end
