class CreateVehicles < ActiveRecord::Migration[5.0]
  def change
    create_table :vehicles do |t|
      t.string :make
      t.string :model
      t.string :year
      t.integer :odometer
      t.string :vin
      t.timestamps
    end
  end
end
