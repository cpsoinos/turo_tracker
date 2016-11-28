class ChangeBackNameOfDistanceOnTrips < ActiveRecord::Migration[5.0]
  def change
    rename_column :trips, :distance_m, :distance
  end
end
