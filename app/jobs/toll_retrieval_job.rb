class TollRetrievalJob < ApplicationJob
  queue_as :default

  def perform(*args)
    TollRetriever.new.retrieve_tolls
  end
end
