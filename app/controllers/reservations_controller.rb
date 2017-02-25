class ReservationsController < ApplicationController

  def index
    @vehicle = Vehicle.find(params[:vehicle_id])
    @reservations = @vehicle.reservations.order(:start_date)
  end

end
