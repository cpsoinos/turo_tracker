class AddLocationToTolls < ActiveRecord::Migration[5.0]
  def change
    add_column :tolls, :exit_location, :string
    add_column :tolls, :travel_agency, :string
  end
end
