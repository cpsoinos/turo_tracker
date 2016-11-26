class AddUrlToVehicles < ActiveRecord::Migration[5.0]
  def change
    add_column :vehicles, :url, :string
  end
end
