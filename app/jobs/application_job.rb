require 'active_job/traffic_control'

class ApplicationJob < ActiveJob::Base
  include ActiveJob::TrafficControl::Throttle
  include ActiveJob::TrafficControl::Concurrency
end
