class DataRetriever

  def execute
    import_trips
    import_tolls
    import_reservations
  end

  def import_trips
    Vehicle.all.each do |vehicle|
      TripRetrievalJob.perform_later(vehicle)
    end
  end

  def import_tolls
    TollRetrievalJob.perform_later
  end

  def import_reservations
    ReservationRetrievalJob.perform_later
  end

end
