class Trip < ApplicationRecord
  belongs_to :vehicle

  def self.remote_objects(vehicle)
    page = 1

    resp = retrieve_trips(vehicle, page)
    trips = resp

    until resp.count < 250
      page += 1
      resp = retrieve_trips(vehicle, page)
      trips += resp
    end

    trips
  end

  def remote_object
    Automatic::Models::Trips.find_by_id(remote_id)
  end

  def self.retrieve_trips(vehicle, page=1)
    Automatic::Models::Trips.all(vehicle: vehicle.remote_id, limit: 250, page: page).to_a
  end

end
