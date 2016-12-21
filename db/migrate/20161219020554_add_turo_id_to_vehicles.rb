class AddTuroIdToVehicles < ActiveRecord::Migration[5.0]
  def change
    add_column :vehicles, :turo_id, :integer
  end
end
