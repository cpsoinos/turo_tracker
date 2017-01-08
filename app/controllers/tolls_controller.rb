class TollsController < ApplicationController

  def index
    @vehicle = Vehicle.find(params[:vehicle_id])
    @tolls = @vehicle.tolls.order(occurred_at: :asc)
  end

end
