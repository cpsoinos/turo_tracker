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

end
