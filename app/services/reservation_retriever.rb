class ReservationRetriever

  attr_reader :vehicles

  def initialize(vehicles=Vehicle.all)
    @vehicles = vehicles
  end

  def retrieve_reservations
    profile = Selenium::WebDriver::Chrome::Profile.new
    download_directory = File.join(Rails.root, 'tmp')
    profile['download.default_directory'] = download_directory
    profile['download.prompt_for_download'] = false

    downloads_before = Dir.entries(download_directory)
    browser = Watir::Browser.new :chrome, profile: profile

    browser.goto("https://turo.com/earnings")
    # login
    browser.text_field(name: 'username').set(ENV["TURO_USERNAME"])
    browser.text_field(name: 'password').set(ENV["TURO_PASSWORD"])
    browser.button(id: 'submit').click # redirected to earnings page

    # download earnings to CSV
    earnings_download_button = browser.div(class: "earnings").div(class: "buttonWrapper").a
    earnings_download_button.click
    sleep(5)

    difference = Dir.entries(download_directory) - downloads_before
    if difference.size == 1
      file_name = difference.first
    end
    browser.close

    parse_csv(file_name)
    create_reservations

    #earnings-display > div > div.earnings > div.buttonWrapper.u-pullRight > a


    # reservation_urls = begin
    #   sleep(10)
    #   browser.divs(class: "earningsRow-description").map do |res|
    #     if res.link.exists?
    #       res.link.href
    #     else
    #       next
    #     end
    #   end.compact
    # end

    # scrape_details(browser, reservation_urls)
  end

  def parse_csv(file)
    filepath = File.join(Rails.root, 'tmp', file)
    @rows = SmarterCSV.process(filepath)
  end

  def transactions
    @_transactions ||= @rows.group_by { |row| row[:reservation_url] }.delete("N/A")
  end

  def reservations
    @_reservations ||= @rows.group_by { |row| row[:reservation_url] }.select { |k,v| k != "N/A" }
  end

  def create_reservations
    reservations.each do |url, earnings|
      turo_reservation_id = extract_reservation_id(url)
      attrs = {
        vehicle: find_vehicle(earnings),
        expected_earnings: find_expected_earnings(earnings),
        reimbursements: find_reimbursements(earnings)
      }
      reservation = Reservation.find_or_create_by(turo_reservation_id: turo_reservation_id)
      reservation.update(attrs)
    end
  end

  def extract_reservation_id(url)
    url.split("/").last
  end

  def find_vehicle(earnings)
    turo_id = earnings.first[:vehicle_id]
    Vehicle.find_by(turo_id: turo_id)
  end

  def find_expected_earnings(earnings)
    amount = earnings.sort_by { |r| r[:date] }.first[:earnings]
    amount = amount.sub("$", "").to_f
    Money.new(amount * 100)
  end

  def find_reimbursements(earnings)
    reimbursements = earnings.sort_by { |r| r[:date] }
    reimbursements.shift
    return nil if reimbursements.nil?

    amount = reimbursements.map { |r| r[:earnings].sub("$", "").to_f }
    Money.new(amount.sum * 100)
  end
  #
  # def find_renter_name(earnings)
  #   earnings.first[:type].split("'").first
  # end

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
