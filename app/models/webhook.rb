class Webhook < ActiveRecord::Base
  belongs_to :vehicle
  after_create :push_notification, if: :should_notify?

  def self.cedar_st_address
    "57 Cedar St., Cambridge, MA"
  end

  def self.cedar_st_lat_lon
    [42.394327, -71.131042]
  end

  def notification_title
    "#{vehicle.name} #{humanized_type}"
  end

  def notification_body
    "#{vehicle.name} #{humanized_type} at #{Webhook.cedar_st_address}"
  end

  def humanized_type
    if webhook_type == "ignition:on"
      "ignition turned on"
    elsif webhook_type == "ignition:off"
      "ignition turned off"
    end
  end

  def push_notification
    pushbullet_client.push_note(
      receiver: :device,
      identifier: ENV['PUSHBULLET_DEVICE_ID'],
      params: {
        title: notification_title,
        body: notification_body
      }
    )
  end

  private

  def pushbullet_client
    @_pushbullet_client ||= Washbullet::Client.new(ENV['PUSHBULLET_ACCESS_TOKEN'])
  end

  def should_notify?
    webhook_type.in?(["ignition:on", "ignition:off"]) &&
    distance([location["lat"], location["lon"]], Webhook.cedar_st_lat_lon) <= 100
  end

  def distance(loc1, loc2)
    rad_per_deg = Math::PI/180  # PI / 180
    rkm = 6371                  # Earth radius in kilometers
    rm = rkm * 1000             # Radius in meters

    dlat_rad = (loc2[0]-loc1[0]) * rad_per_deg  # Delta, converted to rad
    dlon_rad = (loc2[1]-loc1[1]) * rad_per_deg

    lat1_rad, lon1_rad = loc1.map {|i| i * rad_per_deg }
    lat2_rad, lon2_rad = loc2.map {|i| i * rad_per_deg }

    a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
    c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))

    rm * c # Delta in meters
  end

end
