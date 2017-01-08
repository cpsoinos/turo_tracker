class RenterRetrievalJob < ApplicationJob
  queue_as :default

  def perform(*args)
    RenterRetriever.new.retrieve_renters
  end
end
