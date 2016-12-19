class CreateTollsAgain < ActiveRecord::Migration[5.0]
  def change
    create_table :tolls do |t|
      t.datetime :posted_at
      t.datetime :occurred_at
      t.string :memo
      t.string :entry_plaza
      t.string :exit_plaza
      t.monetize :amount
      t.references :vehicle
      t.timestamps
    end
  end
end
