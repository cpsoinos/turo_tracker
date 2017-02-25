class ReservationScraperJob < ApplicationJob
  queue_as :default
  concurrency 5, drop: false

  def perform(reservation)
    ReservationScraper.new(reservation).execute
  end

end
