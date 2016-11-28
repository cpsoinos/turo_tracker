class AddColumnsToTrips < ActiveRecord::Migration[5.0]
  def change
    add_column :trips, :start_location, :jsonb
    add_column :trips, :start_address, :jsonb
    add_column :trips, :end_location, :jsonb
    add_column :trips, :end_address, :jsonb
    add_column :trips, :fuel_volume, :float
    add_column :trips, :tags, :string, array: true
  end
end
