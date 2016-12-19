class AddTransactionTimeToTolls < ActiveRecord::Migration[5.0]
  def change
    add_column :tolls, :transaction_time, :datetime
  end
end
