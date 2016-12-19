class AddTransponderToVehicles < ActiveRecord::Migration[5.0]
  def change
    add_column :vehicles, :transponder, :string
  end
end
