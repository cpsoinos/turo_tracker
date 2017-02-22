namespace :reservations do

  task :scrape_details => :environment do

    reservations = Reservation.where(end_date: nil)
    reservations.each do |reservation|
      ReservationScraperJob.perform_later(reservation)
    end

  end

end
