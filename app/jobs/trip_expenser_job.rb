class TripExpenserJob < ApplicationJob
  queue_as :default

  def perform(trip)
    TripExpenser.new(trip).execute
  end
end
