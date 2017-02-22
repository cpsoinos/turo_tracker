namespace :import do

  task :import => :environment do

    puts "Importing trips"
    TripRetrievalJob.perform_later

    puts "Importing reservations"
    ReservationRetrievalJob.perform_later

    puts "Importing tolls"
    TollRetrievalJob.perform_later

  end

end
