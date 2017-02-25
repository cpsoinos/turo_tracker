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




POST /api/expenses/ HTTP/1.1
Host: xero.automatic.com
Connection: keep-alive
Content-Length: 5033
Pragma: no-cache
Cache-Control: no-cache
Origin: https://xero.automatic.com
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Safari/537.36
Content-Type: application/x-www-form-urlencoded; charset=UTF-8
Accept: */*
X-Requested-With: XMLHttpRequest
Save-Data: on
Referer: https://xero.automatic.com/
Accept-Encoding: gzip, deflate, br
Accept-Language: en-US,en;q=0.8,nb;q=0.6
Cookie: optimizelyEndUserId=oeu1480895470185r0.5061139360405555; ajs_anonymous_id=%22f92b7228-4c4a-4710-84b1-7d625defb435%22; _gat=1; __utmt=1; __utma=105503123.1131651971.1480895473.1486870664.1487083634.7; __utmb=105503123.1.10.1487083634; __utmc=105503123; __utmz=105503123.1487083634.7.7.utmcsr=xero.automatic.com|utmccn=(referral)|utmcmd=referral|utmcct=/; mp_40d708e280f19cd7733e8ba540644197_mixpanel=%7B%22distinct_id%22%3A%20%22158d755933b56e-0f51bc18878186-1d306c51-13c680-158d755933c499%22%2C%22%24initial_referrer%22%3A%20%22https%3A%2F%2Fexpensify.automatic.com%2F%22%2C%22%24initial_referring_domain%22%3A%20%22expensify.automatic.com%22%7D; _fbuy=5056575a0702510d1e03030b021e00000251190051050c1502055659010004010b02000b; mp_mixpanel__c=3; optimizelySegments=%7B%22750333317%22%3A%22referral%22%2C%22750444121%22%3A%22gc%22%2C%22757060269%22%3A%22false%22%7D; optimizelyBuckets=%7B%7D; ajs_user_id=null; ajs_group_id=null; connect.sid=s%3AX_O0RFatNlTznfJpp0Qdc1qPcf5ytQLu.erpUwLsS9AsmImtDggfOvFzGIwjJLFmQy%2Fh4MHhU754; _ga=GA1.2.1131651971.1480895473





{
  "log": {
    "version": "1.2",
    "creator": {
      "name": "WebInspector",
      "version": "537.36"
    },
    "pages": [],
    "entries": [
      {
        "startedDateTime": "2017-02-14T14:49:12.026Z",
        "time": 802.1259999950416,
        "request": {
          "method": "POST",
          "url": "https://xero.automatic.com/api/expenses/",
          "httpVersion": "HTTP/1.1",
          "headers": [
            {
              "name": "Pragma",
              "value": "no-cache"
            },
            {
              "name": "Origin",
              "value": "https://xero.automatic.com"
            },
            {
              "name": "Accept-Encoding",
              "value": "gzip, deflate, br"
            },
            {
              "name": "Host",
              "value": "xero.automatic.com"
            },
            {
              "name": "Accept-Language",
              "value": "en-US,en;q=0.8,nb;q=0.6"
            },
            {
              "name": "User-Agent",
              "value": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Safari/537.36"
            },
            {
              "name": "Content-Type",
              "value": "application/x-www-form-urlencoded; charset=UTF-8"
            },
            {
              "name": "Accept",
              "value": "*/*"
            },
            {
              "name": "Cache-Control",
              "value": "no-cache"
            },
            {
              "name": "X-Requested-With",
              "value": "XMLHttpRequest"
            },
            {
              "name": "Cookie",
              "value": "optimizelyEndUserId=oeu1480895470185r0.5061139360405555; ajs_anonymous_id=%22f92b7228-4c4a-4710-84b1-7d625defb435%22; _gat=1; __utmt=1; __utma=105503123.1131651971.1480895473.1486870664.1487083634.7; __utmb=105503123.1.10.1487083634; __utmc=105503123; __utmz=105503123.1487083634.7.7.utmcsr=xero.automatic.com|utmccn=(referral)|utmcmd=referral|utmcct=/; mp_40d708e280f19cd7733e8ba540644197_mixpanel=%7B%22distinct_id%22%3A%20%22158d755933b56e-0f51bc18878186-1d306c51-13c680-158d755933c499%22%2C%22%24initial_referrer%22%3A%20%22https%3A%2F%2Fexpensify.automatic.com%2F%22%2C%22%24initial_referring_domain%22%3A%20%22expensify.automatic.com%22%7D; _fbuy=5056575a0702510d1e03030b021e00000251190051050c1502055659010004010b02000b; mp_mixpanel__c=3; optimizelySegments=%7B%22750333317%22%3A%22referral%22%2C%22750444121%22%3A%22gc%22%2C%22757060269%22%3A%22false%22%7D; optimizelyBuckets=%7B%7D; ajs_user_id=null; ajs_group_id=null; connect.sid=s%3AX_O0RFatNlTznfJpp0Qdc1qPcf5ytQLu.erpUwLsS9AsmImtDggfOvFzGIwjJLFmQy%2Fh4MHhU754; _ga=GA1.2.1131651971.1480895473"
            },
            {
              "name": "Connection",
              "value": "keep-alive"
            },
            {
              "name": "Referer",
              "value": "https://xero.automatic.com/"
            },
            {
              "name": "Save-Data",
              "value": "on"
            },
            {
              "name": "Content-Length",
              "value": "5033"
            }
          ],
          "queryString": [],
          "cookies": [
            {
              "name": "optimizelyEndUserId",
              "value": "oeu1480895470185r0.5061139360405555",
              "expires": null,
              "httpOnly": false,
              "secure": false
            },
            {
              "name": "ajs_anonymous_id",
              "value": "%22f92b7228-4c4a-4710-84b1-7d625defb435%22",
              "expires": null,
              "httpOnly": false,
              "secure": false
            },
            {
              "name": "_gat",
              "value": "1",
              "expires": null,
              "httpOnly": false,
              "secure": false
            },
            {
              "name": "__utmt",
              "value": "1",
              "expires": null,
              "httpOnly": false,
              "secure": false
            },
            {
              "name": "__utma",
              "value": "105503123.1131651971.1480895473.1486870664.1487083634.7",
              "expires": null,
              "httpOnly": false,
              "secure": false
            },
            {
              "name": "__utmb",
              "value": "105503123.1.10.1487083634",
              "expires": null,
              "httpOnly": false,
              "secure": false
            },
            {
              "name": "__utmc",
              "value": "105503123",
              "expires": null,
              "httpOnly": false,
              "secure": false
            },
            {
              "name": "__utmz",
              "value": "105503123.1487083634.7.7.utmcsr=xero.automatic.com|utmccn=(referral)|utmcmd=referral|utmcct=/",
              "expires": null,
              "httpOnly": false,
              "secure": false
            },
            {
              "name": "mp_40d708e280f19cd7733e8ba540644197_mixpanel",
              "value": "%7B%22distinct_id%22%3A%20%22158d755933b56e-0f51bc18878186-1d306c51-13c680-158d755933c499%22%2C%22%24initial_referrer%22%3A%20%22https%3A%2F%2Fexpensify.automatic.com%2F%22%2C%22%24initial_referring_domain%22%3A%20%22expensify.automatic.com%22%7D",
              "expires": null,
              "httpOnly": false,
              "secure": false
            },
            {
              "name": "_fbuy",
              "value": "5056575a0702510d1e03030b021e00000251190051050c1502055659010004010b02000b",
              "expires": null,
              "httpOnly": false,
              "secure": false
            },
            {
              "name": "mp_mixpanel__c",
              "value": "3",
              "expires": null,
              "httpOnly": false,
              "secure": false
            },
            {
              "name": "optimizelySegments",
              "value": "%7B%22750333317%22%3A%22referral%22%2C%22750444121%22%3A%22gc%22%2C%22757060269%22%3A%22false%22%7D",
              "expires": null,
              "httpOnly": false,
              "secure": false
            },
            {
              "name": "optimizelyBuckets",
              "value": "%7B%7D",
              "expires": null,
              "httpOnly": false,
              "secure": false
            },
            {
              "name": "ajs_user_id",
              "value": "null",
              "expires": null,
              "httpOnly": false,
              "secure": false
            },
            {
              "name": "ajs_group_id",
              "value": "null",
              "expires": null,
              "httpOnly": false,
              "secure": false
            },
            {
              "name": "connect.sid",
              "value": "s%3AX_O0RFatNlTznfJpp0Qdc1qPcf5ytQLu.erpUwLsS9AsmImtDggfOvFzGIwjJLFmQy%2Fh4MHhU754",
              "expires": null,
              "httpOnly": false,
              "secure": false
            },
            {
              "name": "_ga",
              "value": "GA1.2.1131651971.1480895473",
              "expires": null,
              "httpOnly": false,
              "secure": false
            }
          ],
          "headersSize": 1624,
          "bodySize": 5033,
          "postData": {
            "mimeType": "application/x-www-form-urlencoded; charset=UTF-8",
            "text": "trip=%7B%22id%22%3A%22T_1af895d180d4044c%22%2C%22url%22%3A%22https%3A%2F%2Fapi.automatic.com%2Ftrip%2FT_1af895d180d4044c%2F%22%2C%22driver%22%3A%22https%3A%2F%2Fapi.automatic.com%2Fuser%2FU_80f330e9a3ff561e%2F%22%2C%22vehicle%22%3A%7B%22url%22%3A%22https%3A%2F%2Fapi.automatic.com%2Fvehicle%2FC_63fc5baaee4ec589%2F%22%2C%22id%22%3A%22C_63fc5baaee4ec589%22%2C%22created_at%22%3A%222016-09-13T23%3A51%3A26.137000Z%22%2C%22updated_at%22%3A%222017-02-14T12%3A58%3A12.351000Z%22%2C%22make%22%3A%22Pontiac%22%2C%22model%22%3A%22Vibe%22%2C%22year%22%3A2009%2C%22submodel%22%3Anull%2C%22display_name%22%3Anull%2C%22fuel_grade%22%3A%22regular%22%2C%22fuel_level_percent%22%3Anull%2C%22active_dtcs%22%3A%5B%5D%7D%2C%22vehicle_events%22%3A%5B%7B%22g_force%22%3A0.3115799539654781%2C%22lon%22%3A-71.12978788513117%2C%22created_at%22%3A%222017-02-14T12%3A44%3A29.100000Z%22%2C%22type%22%3A%22hard_accel%22%2C%22lat%22%3A42.37778303179557%7D%5D%2C%22duration_s%22%3A1801.9%2C%22distance_m%22%3A5332.5%2C%22fuel_cost_usd%22%3A0.69%2C%22path%22%3A%22wcwaGvvcqL%5C%5C%3F~BCb%40%3F%40j%40fDg%40rCa%40p%40Kf%40INCzASQfB_%40%7CDYdD%60BAHAd%40Ad%40A~BGF%3F%60ACT%3Fl%40A%60%40AD%3FFAJCJCHCLGj%40%5BROl%40%5DNKLGpAw%40h%40%5DzD_CFRPl%40%5E~ABFDHPTJJJNRPz%40~%40l%40r%40r%40x%40hApAdAlAd%40h%40hBtBxAfB%60AfAl%40i%40h%40c%40JKNQDIFMHSBMFWBIBGBE%40CBABCVKBw%40nBH%5C%5C%3Fh%40%40P%40PAXCHAzEw%40%60Dk%40~AWrAS%3FAIoACa%40C%5BAg%40AY%40%5B%40qA%3FQ%3F%5BAMCOCQKe%40e%40kCC%5BAK%3FK%40W%40QBWFa%40D%5DJo%40FUJ_%40JWHQXk%40Zq%40d%40_AP_%40Tk%40JYFQDOFUH%5BRiAJu%40f%40cDbDjA%60EpAl%40FfBb%40z%40R%60%40u%40Vc%40fAaB~%40oAh%40k%40n%40q%40dA%7D%40RMh%40%5DfAq%40h%40c%40LMh%40k%40%5C%5Ce%40R%5Bb%40%7D%40Rm%40HWFYDSHu%40BS%40a%40%40Q%3FS%3Fc%40Aa%40GyAIoBAg%40Ac%40%3Fc%40%40g%40%40s%40%3FQBa%40Hy%40B%5DD%5BBSF_%40DSDOH%5BDQFMPc%40LS%40Ex%40gA%40CHGRQJGRO%60%40ULGl%40YPIl%40SRIVGd%40Oj%40OPEh%40Kl%40KLCVCVCf%40ANA%5E%40%60%40%3FrBJl%40BfBF%60%40%40j%40%40rA%40tCAjBE~AErAGIa%40WeA%22%2C%22fuel_volume_l%22%3A1.2%2C%22hard_brakes%22%3A%22%3Ci+class%3D%5C%22glyphicon+glyphicon-ok%5C%22%3E%3C%2Fi%3E%22%2C%22hard_accels%22%3A1%2C%22duration_over_70_s%22%3A0%2C%22duration_over_75_s%22%3A0%2C%22duration_over_80_s%22%3A0%2C%22average_kmpl%22%3A4.3%2C%22average_from_epa_kmpl%22%3A8.5%2C%22start_address%22%3A%7B%22name%22%3A%2255+Cedar+St%2C+Cambridge%2C+MA+02140%2C+USA%22%2C%22display_name%22%3A%22Cedar+St%2C+Cambridge%2C+MA%22%2C%22street_number%22%3A%2255%22%2C%22street_name%22%3A%22Cedar+St%22%2C%22city%22%3A%22Cambridge%22%2C%22state%22%3A%22MA%22%2C%22country%22%3A%22US%22%2C%22zipcode%22%3Anull%2C%22cleaned%22%3A%2255+Cedar+St%2C+Cambridge%2C+MA+%22%2C%22multiline%22%3A%2255+Cedar+St%3Cbr%3ECambridge%2C+MA+%22%2C%22cityState%22%3A%22Cambridge%2C+MA%22%2C%22street%22%3A%2255+Cedar+St%22%2C%22streetCity%22%3A%22Cedar+St%2C+Cambridge%22%7D%2C%22start_location%22%3A%7B%22lat%22%3A42.39437%2C%22lon%22%3A-71.13121%2C%22accuracy_m%22%3A7.68%7D%2C%22end_address%22%3A%7B%22name%22%3A%22374+River+St%2C+Cambridge%2C+MA+02139%2C+USA%22%2C%22display_name%22%3A%22River+St%2C+Cambridge%2C+MA%22%2C%22street_number%22%3A%22374%22%2C%22street_name%22%3A%22River+St%22%2C%22city%22%3A%22Cambridge%22%2C%22state%22%3A%22MA%22%2C%22country%22%3A%22US%22%2C%22zipcode%22%3Anull%2C%22cleaned%22%3A%22374+River+St%2C+Cambridge%2C+MA+%22%2C%22multiline%22%3A%22374+River+St%3Cbr%3ECambridge%2C+MA+%22%2C%22cityState%22%3A%22Cambridge%2C+MA%22%2C%22street%22%3A%22374+River+St%22%2C%22streetCity%22%3A%22River+St%2C+Cambridge%22%7D%2C%22end_location%22%3A%7B%22lat%22%3A42.36154%2C%22lon%22%3A-71.11516%2C%22accuracy_m%22%3A11.52%7D%2C%22started_at%22%3A%222017-02-14T12%3A26%3A44Z%22%2C%22ended_at%22%3A%222017-02-14T12%3A56%3A45.899000Z%22%2C%22start_timezone%22%3A%22America%2FNew_York%22%2C%22end_timezone%22%3A%22America%2FNew_York%22%2C%22score_events%22%3A46.19%2C%22score_speeding%22%3A50%2C%22city_fraction%22%3A1%2C%22highway_fraction%22%3A0%2C%22night_driving_fraction%22%3A0%2C%22tags%22%3A%5B%5D%2C%22idling_time_s%22%3A500%2C%22user%22%3A%22https%3A%2F%2Fapi.automatic.com%2Fuser%2FU_80f330e9a3ff561e%2F%22%2C%22title%22%3A%22Drive+to+374+River+St%2C+Cambridge%2C+MA++on+Feb+14%2C+2017%22%2C%22dayOfWeek%22%3A%22Tuesday%22%2C%22started_at_time%22%3A%227%3A26+AM%22%2C%22started_at_date%22%3A%22Feb+14%2C+2017%22%2C%22ended_at_time%22%3A%227%3A56+AM%22%2C%22ended_at_date%22%3A%22Feb+14%2C+2017%22%2C%22distance%22%3A%223.3%22%2C%22average_mpg%22%3A%2210.1%22%2C%22hard_brakes_class%22%3A%22no-hard-brakes%22%2C%22hard_accels_class%22%3A%22some-hard-accels%22%2C%22speeding_class%22%3A%22no-speeding%22%2C%22speeding%22%3A%22%3Ci+class%3D%5C%22glyphicon+glyphicon-ok%5C%22%3E%3C%2Fi%3E%22%2C%22fuel_volume_usgal%22%3A0.3170064%2C%22duration%22%3A%2230%22%2C%22duration_type%22%3A%22min%22%2C%22pending%22%3Atrue%2C%22expensed%22%3Atrue%7D&tripID=T_1af895d180d4044c&date=2017-02-14&name=Corey+Psoinos&description=7%3A26+AM+trip+to+Cambridge%2C+MA%2C+3.3+mi+-+via+Automatic&rate=0.54&miles=3.3&accountCode=6722&userID=8ba6078b-0fcf-44b3-a225-55a05769e3e4",
            "params": [
              {
                "name": "trip",
                "value": "%7B%22id%22%3A%22T_1af895d180d4044c%22%2C%22url%22%3A%22https%3A%2F%2Fapi.automatic.com%2Ftrip%2FT_1af895d180d4044c%2F%22%2C%22driver%22%3A%22https%3A%2F%2Fapi.automatic.com%2Fuser%2FU_80f330e9a3ff561e%2F%22%2C%22vehicle%22%3A%7B%22url%22%3A%22https%3A%2F%2Fapi.automatic.com%2Fvehicle%2FC_63fc5baaee4ec589%2F%22%2C%22id%22%3A%22C_63fc5baaee4ec589%22%2C%22created_at%22%3A%222016-09-13T23%3A51%3A26.137000Z%22%2C%22updated_at%22%3A%222017-02-14T12%3A58%3A12.351000Z%22%2C%22make%22%3A%22Pontiac%22%2C%22model%22%3A%22Vibe%22%2C%22year%22%3A2009%2C%22submodel%22%3Anull%2C%22display_name%22%3Anull%2C%22fuel_grade%22%3A%22regular%22%2C%22fuel_level_percent%22%3Anull%2C%22active_dtcs%22%3A%5B%5D%7D%2C%22vehicle_events%22%3A%5B%7B%22g_force%22%3A0.3115799539654781%2C%22lon%22%3A-71.12978788513117%2C%22created_at%22%3A%222017-02-14T12%3A44%3A29.100000Z%22%2C%22type%22%3A%22hard_accel%22%2C%22lat%22%3A42.37778303179557%7D%5D%2C%22duration_s%22%3A1801.9%2C%22distance_m%22%3A5332.5%2C%22fuel_cost_usd%22%3A0.69%2C%22path%22%3A%22wcwaGvvcqL%5C%5C%3F~BCb%40%3F%40j%40fDg%40rCa%40p%40Kf%40INCzASQfB_%40%7CDYdD%60BAHAd%40Ad%40A~BGF%3F%60ACT%3Fl%40A%60%40AD%3FFAJCJCHCLGj%40%5BROl%40%5DNKLGpAw%40h%40%5DzD_CFRPl%40%5E~ABFDHPTJJJNRPz%40~%40l%40r%40r%40x%40hApAdAlAd%40h%40hBtBxAfB%60AfAl%40i%40h%40c%40JKNQDIFMHSBMFWBIBGBE%40CBABCVKBw%40nBH%5C%5C%3Fh%40%40P%40PAXCHAzEw%40%60Dk%40~AWrAS%3FAIoACa%40C%5BAg%40AY%40%5B%40qA%3FQ%3F%5BAMCOCQKe%40e%40kCC%5BAK%3FK%40W%40QBWFa%40D%5DJo%40FUJ_%40JWHQXk%40Zq%40d%40_AP_%40Tk%40JYFQDOFUH%5BRiAJu%40f%40cDbDjA%60EpAl%40FfBb%40z%40R%60%40u%40Vc%40fAaB~%40oAh%40k%40n%40q%40dA%7D%40RMh%40%5DfAq%40h%40c%40LMh%40k%40%5C%5Ce%40R%5Bb%40%7D%40Rm%40HWFYDSHu%40BS%40a%40%40Q%3FS%3Fc%40Aa%40GyAIoBAg%40Ac%40%3Fc%40%40g%40%40s%40%3FQBa%40Hy%40B%5DD%5BBSF_%40DSDOH%5BDQFMPc%40LS%40Ex%40gA%40CHGRQJGRO%60%40ULGl%40YPIl%40SRIVGd%40Oj%40OPEh%40Kl%40KLCVCVCf%40ANA%5E%40%60%40%3FrBJl%40BfBF%60%40%40j%40%40rA%40tCAjBE~AErAGIa%40WeA%22%2C%22fuel_volume_l%22%3A1.2%2C%22hard_brakes%22%3A%22%3Ci+class%3D%5C%22glyphicon+glyphicon-ok%5C%22%3E%3C%2Fi%3E%22%2C%22hard_accels%22%3A1%2C%22duration_over_70_s%22%3A0%2C%22duration_over_75_s%22%3A0%2C%22duration_over_80_s%22%3A0%2C%22average_kmpl%22%3A4.3%2C%22average_from_epa_kmpl%22%3A8.5%2C%22start_address%22%3A%7B%22name%22%3A%2255+Cedar+St%2C+Cambridge%2C+MA+02140%2C+USA%22%2C%22display_name%22%3A%22Cedar+St%2C+Cambridge%2C+MA%22%2C%22street_number%22%3A%2255%22%2C%22street_name%22%3A%22Cedar+St%22%2C%22city%22%3A%22Cambridge%22%2C%22state%22%3A%22MA%22%2C%22country%22%3A%22US%22%2C%22zipcode%22%3Anull%2C%22cleaned%22%3A%2255+Cedar+St%2C+Cambridge%2C+MA+%22%2C%22multiline%22%3A%2255+Cedar+St%3Cbr%3ECambridge%2C+MA+%22%2C%22cityState%22%3A%22Cambridge%2C+MA%22%2C%22street%22%3A%2255+Cedar+St%22%2C%22streetCity%22%3A%22Cedar+St%2C+Cambridge%22%7D%2C%22start_location%22%3A%7B%22lat%22%3A42.39437%2C%22lon%22%3A-71.13121%2C%22accuracy_m%22%3A7.68%7D%2C%22end_address%22%3A%7B%22name%22%3A%22374+River+St%2C+Cambridge%2C+MA+02139%2C+USA%22%2C%22display_name%22%3A%22River+St%2C+Cambridge%2C+MA%22%2C%22street_number%22%3A%22374%22%2C%22street_name%22%3A%22River+St%22%2C%22city%22%3A%22Cambridge%22%2C%22state%22%3A%22MA%22%2C%22country%22%3A%22US%22%2C%22zipcode%22%3Anull%2C%22cleaned%22%3A%22374+River+St%2C+Cambridge%2C+MA+%22%2C%22multiline%22%3A%22374+River+St%3Cbr%3ECambridge%2C+MA+%22%2C%22cityState%22%3A%22Cambridge%2C+MA%22%2C%22street%22%3A%22374+River+St%22%2C%22streetCity%22%3A%22River+St%2C+Cambridge%22%7D%2C%22end_location%22%3A%7B%22lat%22%3A42.36154%2C%22lon%22%3A-71.11516%2C%22accuracy_m%22%3A11.52%7D%2C%22started_at%22%3A%222017-02-14T12%3A26%3A44Z%22%2C%22ended_at%22%3A%222017-02-14T12%3A56%3A45.899000Z%22%2C%22start_timezone%22%3A%22America%2FNew_York%22%2C%22end_timezone%22%3A%22America%2FNew_York%22%2C%22score_events%22%3A46.19%2C%22score_speeding%22%3A50%2C%22city_fraction%22%3A1%2C%22highway_fraction%22%3A0%2C%22night_driving_fraction%22%3A0%2C%22tags%22%3A%5B%5D%2C%22idling_time_s%22%3A500%2C%22user%22%3A%22https%3A%2F%2Fapi.automatic.com%2Fuser%2FU_80f330e9a3ff561e%2F%22%2C%22title%22%3A%22Drive+to+374+River+St%2C+Cambridge%2C+MA++on+Feb+14%2C+2017%22%2C%22dayOfWeek%22%3A%22Tuesday%22%2C%22started_at_time%22%3A%227%3A26+AM%22%2C%22started_at_date%22%3A%22Feb+14%2C+2017%22%2C%22ended_at_time%22%3A%227%3A56+AM%22%2C%22ended_at_date%22%3A%22Feb+14%2C+2017%22%2C%22distance%22%3A%223.3%22%2C%22average_mpg%22%3A%2210.1%22%2C%22hard_brakes_class%22%3A%22no-hard-brakes%22%2C%22hard_accels_class%22%3A%22some-hard-accels%22%2C%22speeding_class%22%3A%22no-speeding%22%2C%22speeding%22%3A%22%3Ci+class%3D%5C%22glyphicon+glyphicon-ok%5C%22%3E%3C%2Fi%3E%22%2C%22fuel_volume_usgal%22%3A0.3170064%2C%22duration%22%3A%2230%22%2C%22duration_type%22%3A%22min%22%2C%22pending%22%3Atrue%2C%22expensed%22%3Atrue%7D"
              },
              {
                "name": "tripID",
                "value": "T_1af895d180d4044c"
              },
              {
                "name": "date",
                "value": "2017-02-14"
              },
              {
                "name": "name",
                "value": "Corey+Psoinos"
              },
              {
                "name": "description",
                "value": "7%3A26+AM+trip+to+Cambridge%2C+MA%2C+3.3+mi+-+via+Automatic"
              },
              {
                "name": "rate",
                "value": "0.54"
              },
              {
                "name": "miles",
                "value": "3.3"
              },
              {
                "name": "accountCode",
                "value": "6722"
              },
              {
                "name": "userID",
                "value": "8ba6078b-0fcf-44b3-a225-55a05769e3e4"
              }
            ]
          }
        },
        "response": {
          "status": 200,
          "statusText": "OK",
          "httpVersion": "HTTP/1.1",
          "headers": [
            {
              "name": "Date",
              "value": "Tue, 14 Feb 2017 14:49:12 GMT"
            },
            {
              "name": "Via",
              "value": "1.1 vegur"
            },
            {
              "name": "Server",
              "value": "Cowboy"
            },
            {
              "name": "X-Powered-By",
              "value": "Express"
            },
            {
              "name": "Etag",
              "value": "W/\"26-Tp70xBa2jNTukbwo+RlCGg\""
            },
            {
              "name": "Content-Type",
              "value": "application/json; charset=utf-8"
            },
            {
              "name": "Connection",
              "value": "keep-alive"
            },
            {
              "name": "Content-Length",
              "value": "38"
            }
          ],
          "cookies": [],
          "content": {
            "size": 38,
            "mimeType": "application/json",
            "compression": 0
          },
          "redirectURL": "",
          "headersSize": 239,
          "bodySize": 38,
          "_transferSize": 277
        },
        "cache": {},
        "timings": {
          "blocked": 3.13999998616055,
          "dns": -1,
          "connect": -1,
          "send": 0.21899997955187978,
          "wait": 796.8870000331666,
          "receive": 1.87999999616261,
          "ssl": -1
        },
        "serverIPAddress": "54.221.221.211",
        "connection": "399484"
      }
    ]
  }
}
