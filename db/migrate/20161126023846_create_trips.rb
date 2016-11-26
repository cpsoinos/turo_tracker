class CreateTrips < ActiveRecord::Migration[5.0]
  def change
    create_table :trips do |t|
      t.string :url
      t.string :remote_id
      t.datetime :started_at
      t.datetime :ended_at
      t.float :distance
      t.float :duration
      t.references :vehicle, foreign_key: true
      t.text :path
      t.float :fuel_cost_usd
      t.timestamps
    end
  end
end
