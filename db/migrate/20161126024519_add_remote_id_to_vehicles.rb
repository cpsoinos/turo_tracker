class AddRemoteIdToVehicles < ActiveRecord::Migration[5.0]
  def change
    add_column :vehicles, :remote_id, :string
  end
end
