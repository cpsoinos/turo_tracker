class ReservationRetriever
  #
  # attr_reader :vehicle
  #
  # def initialize(vehicle)
  #   @vehicle = vehicle
  # end

  def retrieve_reservations
    browser = Watir::Browser.new :chrome#, profile: profile
    browser.goto("https://turo.com/earnings")
    browser.text_field(name: 'username').set(ENV["TURO_USERNAME"])
    browser.text_field(name: 'password').set(ENV["TURO_PASSWORD"])
    browser.button(id: 'submit').click

    reservation_urls = begin
      sleep(10)
      browser.divs(class: "earningsRow-description").map do |res|
        if res.link.exists?
          res.link.href
        else
          next
        end
      end.compact
    end

    scrape_details(browser, reservation_urls)
  end

  def scrape_details(browser, reservation_urls)
    #
    # reservation_ids = begin
    #   browser.divs(class: "js-tripDetails reservationSummary reservationSummary--owner reservationSummary--noDetailPage  booked completed").map do |res|
    #     res.data_reservation_id
    #   end
    # end
    #
    # reservation_ids.each do |id|
    #   browser.goto()
    # end

    # browser.divs(class: "details").each do |div|
    reservation_urls.each do |href|
      browser.goto(href)

      if browser.div(class: "details owner").exists? && browser.div(class: "details owner").h5.exists? && browser.div(class: "details owner").h5.inner_html == "Trip Receipt"
        renter = browser.div(class: "guest").div(class: "content").span.a.inner_html
        s_date = browser.div(class: "scheduleDate js-tripStartDate").inner_html
        s_time = browser.div(class: "scheduleTime js-tripStartTime").inner_html
        e_date = browser.div(class: "scheduleDate js-tripEndDate").inner_html
        e_time = browser.div(class: "scheduleTime js-tripEndTime").inner_html
        expected_earnings_cents = browser.span(class: "currency positive").inner_html.split(('"').last.to_f * 100)
        turo_reservation_id = browser.span(class: "reservation-id").inner_html
        turo_vehicle_id = browser.div(class: "vehicle-image-wrapper").a.href.split("/").last
      else
        renter = browser.div(class: "text--larger u-bold").inner_html
        s_date = browser.divs(class: "schedule-date").first.inner_html
        s_time = browser.divs(class: "schedule-time").first.inner_html
        e_date = browser.divs(class: "schedule-date").last.inner_html
        e_time = browser.divs(class: "schedule-time").last.inner_html
        expected_earnings_cents = (browser.div(class: "reservationDetails-totalEarnings grid-item grid-item--9 u-breakWord").span.inner_html.gsub("$", "").to_f * 100)
        renter_photo_url = browser.img(class: "profilePhoto profilePhoto--medium profilePhoto--round").src
        turo_reservation_id = browser.div(class: "section section--withSmallMargin section--borderTop label label--greyDusty").inner_html.split("#").last
        turo_vehicle_id = browser.div(class: "vehicleDetailsHeader-text").a.href.split("/").last
      end
      reservation = Reservation.find_or_initialize_by(
        vehicle: Vehicle.find_by(turo_id: turo_vehicle_id),
        renter: renter,
        start_date: parse_datetime(s_date, s_time),
        end_date: parse_datetime(e_date, e_time),
        expected_earnings_cents: expected_earnings_cents,
        # remote_renter_photo_url: renter_photo_url,
        turo_reservation_id: turo_reservation_id
      )
      reservation.save
    end
    # page += 1
    # scrape_details(browser, page)
  end

  def parse_datetime(date, time)
    DateTime.parse("#{date} #{time}").change(offset: "-0500")
  end

  def parse_earnings(amount)
    amount.gsub("$", "").to_f * 100
  end

  def parse_vehicle_name(name)
    name = name.split(" ")
    name.pop
    name.join(" ").strip!
  end

end
