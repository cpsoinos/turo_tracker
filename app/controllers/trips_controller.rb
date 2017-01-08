class TripsController < ApplicationController

  def index
    @vehicle = Vehicle.find(params[:vehicle_id])
    @trips = @vehicle.trips
  end

end
