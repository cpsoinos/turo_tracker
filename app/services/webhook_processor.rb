class WebhookProcessor

  attr_reader :data

  def initialize(data)
    @data = data
  end

  def process
    Webhook.create(
      remote_id: data["id"],
      webhook_type: data["type"],
      location: data["location"],
      vehicle: Vehicle.find_by(remote_id: data["vehicle"]["id"]),
      latitude: data["location"]["lat"],
      longitude: data["location"]["longitude"],
      data: data,
      integration: "automatic"
    )
  end

  private

  def webhook
    @_record ||= Webhook.create(integration: "automatic", data: data)
  end

end
