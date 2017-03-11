class ReservationsController < ApplicationController

  def index
    @vehicle = Vehicle.find(params[:vehicle_id])
    @reservations = @vehicle.reservations.includes(:renter, :vehicle).order(:start_date)
  end

end
