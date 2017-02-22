class TollRetriever

  attr_reader :vehicle

  def retrieve_tolls
    profile = Selenium::WebDriver::Chrome::Profile.new
    download_directory = File.join(Rails.root, 'tmp')
    profile['download.default_directory'] = download_directory
    profile['download.prompt_for_download'] = false

    downloads_before = Dir.entries(download_directory)
    browser = Watir::Browser.new :chrome, profile: profile

    # login page
    browser.goto('https://www.ezdrivema.com/ezpassmalogin')
    browser.text_field(name: 'dnn$ctr689$View$txtUserName').set(ENV['EZDRIVE_USERNAME'])
    browser.text_field(name: 'dnn$ctr689$View$txtPassword').set(ENV['EZDRIVE_PASSWORD'])
    browser.link(id: "btnLogin").click

    # transactions page
    browser.goto("https://www.ezdrivema.com/ezpassviewtransactions")
    # browser.text_field(name: 'dnn$ctr1180$ucMassDotTcoreTransaction$ucBaseTcoreTransaction$TransponderNumberTextBox').set(vehicle.transponder)
    browser.text_field(name: 'dnn$ctr1180$ucMassDotTcoreTransaction$ucBaseTcoreTransaction$txtStartDate').click

    # set start date
    browser.text_field(name: 'dnn$ctr1180$ucMassDotTcoreTransaction$ucBaseTcoreTransaction$txtStartDate').set("1/1/2017")
    sleep(1)
    # search
    browser.link(id: 'dnn_ctr1180_ucMassDotTcoreTransaction_ucBaseTcoreTransaction_SearchButton').click
    sleep(5)
    # download
    browser.link(href: '/report?report=transcsv').click
    sleep(3)

    difference = Dir.entries(download_directory) - downloads_before
    if difference.size == 1
      file_name = difference.first
    end
    browser.close
    extract_tolls(file_name)
  end

  def extract_tolls(file)
    filepath = File.join(Rails.root, 'tmp', file)
    @rows = SmarterCSV.process(filepath)

    @rows.each do |row|
      attributes = {
        posted_at: format_datetime(row[:posting_date]),
        occurred_at: format_datetime_military(row[:exit_date_time]),
        memo: row[:transaction],
        exit_location: row[:exit_lane],
        travel_agency: row[:travel_agency],
        amount_cents: (row[:amount].to_f * -100),
        vehicle: Vehicle.find_by(transponder: row[:'tag_/_license'].to_s[3..-1])
      }

      Toll.find_or_create_by(attributes)
    end

    # require 'csv'
    # csv = CSV.read(File.join(Rails.root, 'tmp', file))
    # csv.shift # remove header row
    # csv.each do |row|
    #   row.map { |cell| cell.try(:strip!) }
    #   attributes = {
    #     vehicle: vehicle,
    #     posted_at: format_datetime(row[0]),
    #     occurred_at: format_datetime(row[1]),
    #     memo: row[2],
    #     amount_cents: (row.last.to_f * 100)
    #   }
    #   toll = Toll.find_or_create_by(attributes)
    # end
  end

  def format_datetime(timestamp)
    return if timestamp.nil?
    begin
      DateTime.strptime(timestamp, '%m/%d/%Y %H:%M:%S %p').change(offset: "-0500")
    rescue ArgumentError
      nil
    end
  end

  def format_datetime_military(timestamp)
    return if timestamp.nil?
    begin
      DateTime.strptime(timestamp, '%m/%d/%Y %H:%M:%S').change(offset: "-0500")
    rescue ArgumentError
      nil
    end
  end

end
