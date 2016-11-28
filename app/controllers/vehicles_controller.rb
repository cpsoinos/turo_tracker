class VehiclesController < ApplicationController

  def index
    @vehicles = Vehicle.all
  end

  def import
    VehicleImporter.new(current_user).import
  end

end
