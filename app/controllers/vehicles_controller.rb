class VehiclesController < ApplicationController

  def index
    @vehicles = Vehicle.all.order(:id)
  end

  def show
    @vehicle = Vehicle.find(params[:id])
  end

  def edit
    @vehicle = Vehicle.find(params[:id])
  end

  def update
    @vehicle = Vehicle.find(params[:id])
    if @vehicle.update(vehicle_params)
      render :show
    end
  end

  protected

  def vehicle_params
    params.require(:vehicle).permit(:make, :model, :year, :vin, :odometer, :url, :remote_id, :photo, :edmunds_id, :transponder, :turo_id)
  end

end
