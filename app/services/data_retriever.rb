class DataRetriever

  def execute
    import_trips
    import_tolls
    import_reservations
  end

  def import_trips
    TripRetrievalJob.perform_later
  end

  def import_tolls
    TollRetrievalJob.perform_later
  end

  def import_reservations
    ReservationRetrievalJob.perform_later
  end

end
