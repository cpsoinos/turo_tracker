class ReservationScraper

  attr_reader :reservation

  def initialize(reservation)
    @reservation = reservation
  end

  def execute
    return unless reservation.expected_earnings_cents > 0
    Watir.default_timeout = 90
    login
    scrape_details
  end

  private

  def browser
    @_browser ||= Watir::Browser.new :phantomjs, args: phantom_switches
  end

  def phantom_switches
    ['--load-images=no', '--ignore-ssl-errors=yes']
  end

  def login
    browser.goto("https://turo.com/dashboard")
    browser.text_field(name: 'username').set(ENV["TURO_USERNAME"])
    browser.text_field(name: 'password').set(ENV["TURO_PASSWORD"])
    browser.button(id: 'submit').click
    sleep(3)
  end

  def scrape_details
    browser.goto(reservation.url)
    reservation.miles_included = browser.div(class: "reservationDetails-milesIncluded").inner_html.match('(?<=-->)(.*)(?=<!)')[1].sub(" miles", "").sub(",", "").to_i

    browser.goto(reservation.receipt_url)

    pickup_summary = browser.div(class: "reservationSummary-schedulePickUp")
    s_date = pickup_summary.span(class: "scheduleDate").inner_html
    s_time = pickup_summary.span(class: "scheduleTime").inner_html

    dropoff_summary = browser.div(class: "reservationSummaryDropOff")
    e_date = dropoff_summary.span(class: "scheduleDate").inner_html
    e_time = dropoff_summary.span(class: "scheduleTime").inner_html

    reservation.start_date = parse_datetime(s_date, s_time)
    reservation.end_date = parse_datetime(e_date, e_time)

    expected_total = browser.span(class: "value earned total").span(class: "currency positive").inner_html.sub("$", "").to_f
    reservation.expected_earnings = Money.new(expected_total * 100)

    if browser.text.include?("REIMBURSEMENT TOTAL")
      reimbursements_total = browser.spans(class: "currency positive").to_a.last.inner_html.sub("$", "").to_f
      reservation.reimbursements = Money.new(reimbursements_total * 100)
    end

    reservation.save
  end

  def parse_datetime(date, time)
    begin
      DateTime.parse("#{date} #{time}").change(offset: "-0500")
    rescue
      nil
    end
  end

end
