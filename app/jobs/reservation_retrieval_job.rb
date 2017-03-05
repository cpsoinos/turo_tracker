class ReservationRetrievalJob < ApplicationJob
  queue_as :default

  def perform(*args)
    ReservationRetriever.new.retrieve_reservations
    RenterRetrievalJob.perform_later
  end
end
