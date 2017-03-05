class TripRetrievalJob < ApplicationJob
  queue_as :default

  def perform(vehicle)
    TripImporter.new(vehicle).import
  end
end
