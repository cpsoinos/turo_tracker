class VehicleImporter

  def import
    create_vehicles_from_remote
  end

  private

  def remote_vehicles
    @_remote_vehicles ||= Vehicle.remote_objects
  end

  def create_vehicles_from_remote
    remote_vehicles.map do |rv|
      Vehicle.find_or_create_by(
        make: rv.make,
        model: rv.model,
        year: rv.year,
        url: rv.url,
        remote_id: rv.id
      )
    end
  end

end
