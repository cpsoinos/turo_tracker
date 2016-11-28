class TripImporter

  attr_reader :vehicle

  def initialize(vehicle)
    @vehicle = vehicle
  end

  def import
    create_trips_from_remote
  end

  private

  def remote_trips
    @_remote_trips ||= Trip.remote_objects(vehicle)
  end

  def create_trips_from_remote
    remote_trips.map do |rt|
      vehicle.trips.find_or_create_by(
        remote_id: rt.id,
        url: rt.url,
        started_at: rt.started_at,
        ended_at: rt.ended_at,
        distance: convert_distance(rt),
        path: rt.path,
        fuel_cost_usd: rt.fuel_cost_usd,
        start_location: rt.start_location,
        start_address: rt.start_address,
        end_location: rt.end_location,
        end_address: rt.end_address,
        fuel_volume: rt.fuel_volume,
        # tags:
      )
    end
  end

  def convert_distance(remote_trip)
    remote_trip.distance_m.meters.to.miles.value
  end

end
