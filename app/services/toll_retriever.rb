class TollRetriever

  attr_reader :vehicle

  def initialize(vehicle)
    @vehicle = vehicle
  end

  def retrieve_tolls
    profile = Selenium::WebDriver::Chrome::Profile.new
    download_directory = File.join(Rails.root, 'tmp')
    profile['download.default_directory'] = download_directory
    profile['download.prompt_for_download'] = false

    downloads_before = Dir.entries(download_directory)

    browser = Watir::Browser.new :chrome, profile: profile
    browser.goto('https://www.ezdrivema.com/ezpassmalogin')
    browser.text_field(name: 'dnn$ctr689$View$txtUserName').set(ENV['EZDRIVE_USERNAME'])
    browser.text_field(name: 'dnn$ctr689$View$txtPassword').set(ENV['EZDRIVE_PASSWORD'])
    browser.link(id: "btnLogin").click
    browser.goto("https://www.ezdrivema.com/ezpassviewtransactions")
    browser.text_field(name: 'dnn$ctr1180$ucMassDotTcoreTransaction$ucBaseTcoreTransaction$TransponderNumberTextBox').set(vehicle.transponder)
    browser.text_field(name: 'dnn$ctr1180$ucMassDotTcoreTransaction$ucBaseTcoreTransaction$txtStartDate').click
    browser.td(id: "dnn_ctr1180_ucMassDotTcoreTransaction_ucBaseTcoreTransaction_txtStartDate_B-1").click
    browser.tds(class: 'dxeCalendarDay').detect { |cell| cell.inner_html == '1' }.click
    browser.select_list(name: 'dnn$ctr1180$ucMassDotTcoreTransaction$ucBaseTcoreTransaction$ddlTransactionsPerPage').select(50)
    browser.link(id: 'dnn_ctr1180_ucMassDotTcoreTransaction_ucBaseTcoreTransaction_SearchButton').click
    browser.link(id: 'dnn_ctr1180_ucMassDotTcoreTransaction_ucBaseTcoreTransaction_hlDownload').click
    sleep(3)

    difference = Dir.entries(download_directory) - downloads_before
    if difference.size == 1
      file_name = difference.first
    end
    browser.close
    extract_tolls(file_name)
  end

  def extract_tolls(file)
    require 'csv'
    csv = CSV.read(File.join(Rails.root, 'tmp', file))
    csv.shift # remove header row
    csv.each do |row|
      row.map { |cell| cell.try(:strip!) }
      attributes = {
        vehicle: vehicle,
        posted_at: format_datetime(row[0]),
        occurred_at: format_datetime(row[1]),
        memo: row[2],
        amount_cents: (row.last.to_f * 100)
      }
      toll = Toll.find_or_create_by(attributes)
    end
  end

  def format_datetime(timestamp)
    return if timestamp.nil?
    DateTime.strptime(timestamp, '%m/%d/%Y %H:%M:%S %p').change(offset: "-0500")
  end

end
