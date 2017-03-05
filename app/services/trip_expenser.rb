class TripExpenser

  attr_reader :trip

  def initialize(trip)
    @trip = trip
  end

  def execute
    return if trip.expensed?
    expense
    trip.expensed = true
    trip.save
  end

  private

  def base_params
    JSON.parse(remote_object.to_json)["attributes"]
  end

  def expense_params
    base_params.merge({
      distance: trip.distance.to_s,
      title: "Trip to #{end_address}",
      dayOfWeek: trip.ended_at.strftime("%A"),
      started_at_time: trip.started_at.localtime.strftime("%l:%M %p").strip,
      started_at_date: trip.started_at.localtime.strftime("%b %d, %Y").strip,
      ended_at_time: trip.ended_at.localtime.strftime("%l:%M %p").strip,
      ended_at_date: trip.ended_at.localtime.strftime("%b %d, %Y").strip,
      average_mpg: calculate_mpg,
      # hard_brakes_class: ,
      # hard_accels_class: ,
      # speeding_class: ,
      # speeding: ,
      fuel_volume_usgal: trip.fuel_volume.to_s,
      isWeekend: weekend?,
      comment: comment,
      duration: duration,
      duration_type: "min",
      pending: true,
      expensed: true
    })
  end

  def start_address
    trip.start_address["attributes"]["name"][0..-12]
  end

  def end_address
    trip.end_address["attributes"]["name"][0..-12]
  end

  def calculate_mpg
    (remote_object.average_kmpl.to_f * 2.35215).to_s
  end

  def comment
    "#{trip.vehicle.name} - #{trip.distance.round(1)} mi trip from #{start_address} to #{end_address} on #{trip.started_at.localtime.strftime("%b %d, %Y").strip} at #{trip.started_at.localtime.strftime("%l:%M %p").strip} - Via Automatic"
  end

  def weekend?
    trip.started_at.strftime("%A").in?(%w(Saturday Sunday))
  end

  def duration
    (trip.duration / 60).round.to_s
  end

  def remote_object
    @_remote_object ||= trip.remote_object
  end

  def expense
    uri = URI.parse("https://expensify.automatic.com/api/expenses/")
    request = Net::HTTP::Post.new(uri)
    request.content_type = "application/x-www-form-urlencoded; charset=UTF-8"
    request["Cookie"] = "optimizelyEndUserId=oeu1480895470185r0.5061139360405555; ajs_anonymous_id=%22f92b7228-4c4a-4710-84b1-7d625defb435%22; _gat=1; ajs_user_id=null; ajs_group_id=null; optimizelySegments=%7B%22750333317%22%3A%22referral%22%2C%22750444121%22%3A%22gc%22%2C%22757060269%22%3A%22false%22%7D; optimizelyBuckets=%7B%227981621280%22%3A%227979861190%22%2C%227947491299%22%3A%227954790115%22%7D; mp_40d708e280f19cd7733e8ba540644197_mixpanel=%7B%22distinct_id%22%3A%20%22158d755933b56e-0f51bc18878186-1d306c51-13c680-158d755933c499%22%2C%22%24initial_referrer%22%3A%20%22https%3A%2F%2Fexpensify.automatic.com%2F%22%2C%22%24initial_referring_domain%22%3A%20%22expensify.automatic.com%22%7D; __utmt=1; __utma=105503123.1131651971.1480895473.1482287943.1483138405.4; __utmb=105503123.1.10.1483138405; __utmc=105503123; __utmz=105503123.1483138405.4.4.utmcsr=expensify.automatic.com|utmccn=(referral)|utmcmd=referral|utmcct=/; _fbuy=5056575a0702510d1e03030b021e00000251190051050c1502055659010004010b02000b; mp_mixpanel__c=3; connect.sid=s%3AnRnbVjylLWt6HOY55YKir0oYyIRzDklB.D1qObrM%2B060E7eQ503murHyqFXcI19qjsLfEnGS%2Fngw; _ga=GA1.2.1131651971.1480895473"
    request["Origin"] = "https://expensify.automatic.com"
    request["Accept-Language"] = "en-US,en;q=0.8,nb;q=0.6"
    request["User-Agent"] = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.95 Safari/537.36"
    request["Accept"] = "*/*"
    request["Referer"] = "https://expensify.automatic.com/"
    request["X-Requested-With"] = "XMLHttpRequest"
    request["Connection"] = "keep-alive"
    request["Save-Data"] = "on"
    request.set_form_data(
      "trip" => expense_params.to_json,
      "tripID" => trip.remote_id,
      "created" => trip.ended_at.strftime("%Y-%m-%d"),
      "comment" => comment,
      "distance" => trip.distance.round(1).to_s,
      "rate" => "0.54",
    )

    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    response
  end

end
