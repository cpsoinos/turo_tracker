class TollsController < ApplicationController

  def index
    @vehicle = Vehicle.find(params[:vehicle_id])
    @reservation = Reservation.find(params[:reservation_id]) if params[:reservation_id]
    if @reservation
      @tolls = @reservation.tolls.order(occurred_at: :asc)
    else
      @tolls = @vehicle.tolls.order(occurred_at: :asc)
    end
  end

end
