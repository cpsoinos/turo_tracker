class Trip < ApplicationRecord
  belongs_to :vehicle

  # def self.by_vehicle(vehicle)
  #   trip_list = []
  # end
  #
  # private
  #
  # def all_trips_by_vehicle(vehicle)
  #   all_trips = []
  # end
  #
  # def retrieve_trips(vehicle, page=1)
  #   trips = retrieve_trips(vehicle, page)
  #   # trips = Automatic::Models::Trips.all(vehicle: vehicle.remote_id, limit: 250, page: page).to_a
  #   if trips.count >= 250
  #     page += 1
  #     more_trips = Automatic::Models::Trips.all(vehicle: vehicle.remote_id, limit: 250, page: page).to_a
  #   end
  # end
  #
  # def retrieve_trips(vehicle, page)
  #   Automatic::Models::Trips.all(vehicle: vehicle.remote_id, limit: 250, page: page).to_a
  # end

end
