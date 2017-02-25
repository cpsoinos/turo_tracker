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
      vehicle = find_vehicle(earnings)
      attrs = {
        expected_earnings: find_expected_earnings(earnings),
        reimbursements: find_reimbursements(earnings)
      }
      reservation = vehicle.reservations.find_or_create_by(turo_reservation_id: turo_reservation_id)
      reservation.update(attrs)
      scrape_details(reservation)
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

  def scrape_details(reservation)
    if reservation.end_date.nil?
      ReservationScraperJob.perform_later(reservation)
    end
  end

end
