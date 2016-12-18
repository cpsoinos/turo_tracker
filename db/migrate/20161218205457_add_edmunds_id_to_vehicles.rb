class AddEdmundsIdToVehicles < ActiveRecord::Migration[5.0]
  def change
    add_column :vehicles, :edmunds_id, :bigint
  end
end
