namespace :trips do

  task :import => :environment do

    vehicles = Vehicle.all
    vehicles.each do |vehicle|
      puts "Importing new trips for #{vehicle.name}"
      TripImporter.new(vehicle).import
    end

  end
  
end
