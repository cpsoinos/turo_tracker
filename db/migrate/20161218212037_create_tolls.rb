class CreateTolls < ActiveRecord::Migration[5.0]
  def change
    create_table :tolls do |t|
      t.datetime :post_date
      t.datetime :exit_date_time
      t.string :transaction
      t.string :transponder_id
      t.string :entry_plaza
      t.string :exit_plaza
      t.string :class
      t.monetize :amount
      t.references :trip
      t.references :vehicle
      t.timestamps
    end
  end
end
