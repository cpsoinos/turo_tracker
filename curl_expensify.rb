
require 'net/http'
require 'uri'

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
  "trip" => "{\"id\":\"T_309eef3960a20f12\",\"url\":\"https://api.automatic.com/trip/T_309eef3960a20f12/\",\"driver\":\"https://api.automatic.com/user/U_80f330e9a3ff561e/\",\"vehicle\":{\"url\":\"https://api.automatic.com/vehicle/C_63fc5baaee4ec589/\",\"id\":\"C_63fc5baaee4ec589\",\"created_at\":\"2016-09-13T23:51:26.137000Z\",\"updated_at\":\"2016-12-30T22:41:10.550000Z\",\"make\":\"Pontiac\",\"model\":\"Vibe\",\"year\":2009,\"submodel\":null,\"display_name\":null,\"fuel_grade\":\"regular\",\"fuel_level_percent\":null,\"active_dtcs\":[]},\"vehicle_events\":[],\"duration_s\":1199.4,\"distance_m\":2306.9,\"fuel_cost_usd\":0.3,\"path\":\"}juaGbxeqLq@KuBUc@OKCKEYMAGACCGACAM?KAS?E?MDe@DKJ]BC\\\\oAhA{CZeAh@{Ab@oA`@mA`AuCb@oA\\\\aAX}@Pi@r@uBt@uBi@s@_AeAiAqAs@y@m@s@{@_ASQKOKKQUEICG_@_BQm@GS{D~Bi@\\\\qAv@MFOJm@\\\\SNk@ZMFIBKBKBG@E?a@@m@@U?aABG?_CFe@@e@@I@aB@oHNyCFHaDD}A@e@@eAAk@c@?_CB]?J?\",\"fuel_volume_l\":0.5,\"hard_brakes\":\"<i class=\\\"glyphicon glyphicon-ok\\\"></i>\",\"hard_accels\":\"<i class=\\\"glyphicon glyphicon-ok\\\"></i>\",\"duration_over_70_s\":0,\"duration_over_75_s\":0,\"duration_over_80_s\":0,\"average_kmpl\":4.6,\"average_from_epa_kmpl\":8.5,\"start_address\":{\"name\":\"343 Fresh Pond Pkwy, Cambridge, MA 02138, USA\",\"display_name\":\"Fresh Pond Pkwy, Cambridge, MA\",\"street_number\":\"343\",\"street_name\":\"Fresh Pond Pkwy\",\"city\":\"Cambridge\",\"state\":\"MA\",\"country\":\"US\",\"zipcode\":null,\"cleaned\":\"343 Fresh Pond Pkwy, Cambridge, MA \",\"multiline\":\"343 Fresh Pond Pkwy<br>Cambridge, MA \",\"cityState\":\"Cambridge, MA\",\"street\":\"343 Fresh Pond Pkwy\",\"streetCity\":\"Fresh Pond Pkwy, Cambridge\"},\"start_location\":{\"lat\":42.3852,\"lon\":-71.14087,\"accuracy_m\":7.68},\"end_address\":{\"name\":\"57 Cedar St, Cambridge, MA 02140, USA\",\"display_name\":\"Cedar St, Cambridge, MA\",\"street_number\":\"57\",\"street_name\":\"Cedar St\",\"city\":\"Cambridge\",\"state\":\"MA\",\"country\":\"US\",\"zipcode\":null,\"cleaned\":\"57 Cedar St, Cambridge, MA \",\"multiline\":\"57 Cedar St<br>Cambridge, MA \",\"cityState\":\"Cambridge, MA\",\"street\":\"57 Cedar St\",\"streetCity\":\"Cedar St, Cambridge\"},\"end_location\":{\"lat\":42.39429,\"lon\":-71.13114,\"accuracy_m\":8.64},\"started_at\":\"2016-12-30T22:08:12.600000Z\",\"ended_at\":\"2016-12-30T22:28:12Z\",\"start_timezone\":\"America/New_York\",\"end_timezone\":\"America/New_York\",\"score_events\":50,\"score_speeding\":50,\"city_fraction\":1,\"highway_fraction\":0,\"night_driving_fraction\":0,\"tags\":[],\"idling_time_s\":300,\"user\":\"https://api.automatic.com/user/U_80f330e9a3ff561e/\",\"distance\":\"1.4\",\"title\":\"Drive to 57 Cedar St, Cambridge, MA  on Dec 30, 2016\",\"dayOfWeek\":\"Friday\",\"started_at_time\":\"5:08 PM\",\"started_at_date\":\"Dec 30, 2016\",\"ended_at_time\":\"5:28 PM\",\"ended_at_date\":\"Dec 30, 2016\",\"average_mpg\":\"10.8\",\"hard_brakes_class\":\"no-hard-brakes\",\"hard_accels_class\":\"no-hard-accels\",\"speeding_class\":\"no-speeding\",\"speeding\":\"<i class=\\\"glyphicon glyphicon-ok\\\"></i>\",\"fuel_volume_usgal\":0.132086,\"isWeekend\":false,\"comment\":\"1.4 mi trip from 343 Fresh Pond Pkwy, Cambridge, MA  to 57 Cedar St, Cambridge, MA  on Dec 30, 2016 at 5:08 PM - via Automatic\",\"duration\":\"20\",\"duration_type\":\"min\",\"pending\":true,\"expensed\":true}",
  "tripID" => "T_309eef3960a20f12",
  "created" => "2016-12-30",
  "comment" => "1.4 mi trip from 343 Fresh Pond Pkwy, Cambridge, MA  to 57 Cedar St, Cambridge, MA  on Dec 30, 2016 at 5:08 PM - via Automatic",
  "distance" => "1.4",
  "rate" => "0.54",
)

req_options = {
  use_ssl: uri.scheme == "https",
}

response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
  http.request(request)
end

puts response.code
puts response.body
