class ReservationRetrievalJob < ApplicationJob
  queue_as :default

  def perform(*args)
    ReservationRetriever.new.retrieve_reservations
  end
end
