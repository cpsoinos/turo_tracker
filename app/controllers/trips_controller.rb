class TripsController < ApplicationController

  def index
    @vehicle = Vehicle.find(params[:vehicle_id])
    @reservation = Reservation.find(params[:reservation_id])
    if @reservation
      @trips = @reservation.trips.order(:started_at)
    else
      @trips = @vehicle.trips.order(:started_at)
    end
  end

end
