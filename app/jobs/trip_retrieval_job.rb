class TripRetrievalJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Vehicle.all.each do |vehicle|
      TripImporter.new(vehicle).import
    end
  end
end
