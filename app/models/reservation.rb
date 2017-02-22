class Reservation < ApplicationRecord
  # has_many :trips
  belongs_to :vehicle
  belongs_to :renter, optional: true

  monetize :expected_earnings_cents, allow_nil: true, numericality: {
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 100000
  }
  monetize :reimbursements_cents, allow_nil: true, numericality: {
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 100000
  }

  def trips
    vehicle.trips.where("started_at > ? AND ended_at < ?", self.start_date, self.end_date)
  end

  def tolls
    vehicle.tolls.where(occurred_at: start_date..end_date)
  end

  def tolls_incurred
    Money.new(tolls.sum(:amount_cents))
  end

  def url
    "https://turo.com/reservation/#{turo_reservation_id}"
  end

  def receipt_url
    "https://turo.com/reservation/#{turo_reservation_id}/receipt"
  end

  def miles_traveled
    trips.sum(:distance).round
  end

  def scrape_details
    login
    browser.goto(receipt_url)
    # browser.text_field(name: 'username').set(ENV["TURO_USERNAME"])
    # browser.text_field(name: 'password').set(ENV["TURO_PASSWORD"])
    # browser.button(id: 'submit').click

    # schedule_div = browser.div(class: "reservationDetails-schedule")

    pickup_summary = browser.div(class: "reservationSummary-schedulePickUp")
    s_date = pickup_summary.span(class: "scheduleDate").inner_html
    s_time = pickup_summary.span(class: "scheduleTime").inner_html

    dropoff_summary = browser.div(class: "reservationSummaryDropOff")
    e_date = dropoff_summary.span(class: "scheduleDate").inner_html
    e_time = dropoff_summary.span(class: "scheduleTime").inner_html

    # s_date = browser.divs(class: "schedule-date").first.inner_html
    # s_time = browser.divs(class: "schedule-time").first.inner_html
    # e_date = browser.divs(class: "schedule-date").last.inner_html
    # e_time = browser.divs(class: "schedule-time").last.inner_html

    self.start_date = parse_datetime(s_date, s_time)
    self.end_date = parse_datetime(e_date, e_time)

    expected_total = browser.span(class: "value earned total").span(class: "currency positive").inner_html.sub("$", "").to_f
    self.expected_earnings = Money.new(expected_total * 100)

    if browser.text.include?("REIMBURSEMENT TOTAL")
      reimbursements_total = browser.spans(class: "currency positive").to_a.last.inner_html.sub("$", "").to_f
      self.reimbursements = Money.new(reimbursements_total * 100)
    end

    self.save

    # find_renter

    browser.close
  end

  private

  def browser
    @_browser ||= Watir::Browser.new :phantomjs, args: phantom_switches
    # @_browser ||= Watir::Browser.new :chrome
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

  def parse_datetime(date, time)
    DateTime.parse("#{date} #{time}").change(offset: "-0500")
  end

  # def find_renter
  #   renter_name = browser.div(class: "text--larger u-bold").inner_html
  #   renter_photo = browser.img(class: "profilePhoto profilePhoto--medium profilePhoto--round")
  #   photo_container = renter_photo.parent
  #   renter_link = photo_container.parent.href
  #   renter_turo_id = renter_link.split("/").last
  #
  #   browser.goto(renter_link)
  #   renter_photo_url = browser.img(class: "profilePhoto--uploader").src
  #
  #   attrs = {
  #     name: renter_name,
  #     remote_photo_url: renter_photo_url
  #   }
  #
  #   renter = Renter.find_or_create_by(turo_id: renter_turo_id)
  #   renter.update(attrs)
  #   self.renter = renter
  #   self.save
  # end

end
