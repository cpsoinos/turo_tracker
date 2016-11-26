class ChangeNameOfDistanceOnTrips < ActiveRecord::Migration[5.0]
  def change
    rename_column :trips, :distance, :distance_m
  end
end
