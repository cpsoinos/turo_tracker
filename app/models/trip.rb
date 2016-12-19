class Trip < ApplicationRecord
  belongs_to :vehicle
  # has_many :tolls

  def self.remote_objects(vehicle)
    page = 1

    resp = retrieve_trips(vehicle, page)
    trips = resp

    until resp.count < 250
      page += 1
      resp = retrieve_trips(vehicle, page)
      trips += resp
    end

    trips
  end

  def remote_object
    Automatic::Models::Trips.find_by_id(remote_id)
  end

  def self.retrieve_trips(vehicle, page=1)
    Automatic::Models::Trips.all(vehicle: vehicle.remote_id, limit: 250, page: page).to_a
  end

  def tag_business
    require 'net/http'
    require 'uri'

    uri = URI.parse("https://api.automatic.com/trip/#{remote_id}/tag/")
    request = Net::HTTP::Post.new(uri)
    request["Authorization"] = "Bearer #{ENV['AUTOMATIC_ACCESS_TOKEN']}"
    request.set_form_data(
      "tag" => "business",
    )

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
      http.request(request)
    end

    JSON.parse(response.body)

  end

end
